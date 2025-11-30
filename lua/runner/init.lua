local M = {}

--------------------------------------------------------------------------------
-- CONFIGURATION
--------------------------------------------------------------------------------

-- Files we look for (in order of priority)
local RUN_FILES = { ".run", ".runner" }

--------------------------------------------------------------------------------
-- CORE UTILITIES
--------------------------------------------------------------------------------

--- Find the project root by searching upward for a .run/.runner file
--- @return string|nil root The project root directory, or nil if not found
function M.get_root()
	-- Get the directory of the current file
	-- %:p = full path to current file
	-- %:p:h = head (directory) of that path
	local current_file = vim.fn.expand("%:p:h")

	-- Search upward from current file's directory
	-- Returns a list of matches (we only care about first)
	local result = vim.fs.find(RUN_FILES, {
		upward = true,
		path = current_file,
	})

	if result[1] then
		-- vim.fs.dirname extracts directory from a path
		-- "/home/user/project/.run" -> "/home/user/project"
		return vim.fs.dirname(result[1])
	end

	return nil
end

--- Get the path to the .run file
--- @return string|nil path The full path to the .run file, or nil
function M.get_run_file_path()
	local root = M.get_root()
	if not root then
		return nil
	end

	-- Check each possible filename in order
	for _, name in ipairs(RUN_FILES) do
		local path = root .. "/" .. name
		-- vim.fn.filereadable returns 1 if file exists and is readable
		if vim.fn.filereadable(path) == 1 then
			return path
		end
	end

	return nil
end

--- Get all commands from the .run file
--- @return table|nil commands List of {line_number, command} pairs, or nil
--- @return string|nil root The project root
function M.get_commands()
	local root = M.get_root()
	if not root then
		vim.notify("No .run file found", vim.log.levels.WARN)
		return nil, nil
	end

	local path = M.get_run_file_path()
	if not path then
		return nil, nil
	end

	local commands = {}

	-- io.lines returns an iterator over each line in the file
	-- This is memory efficient for large files (reads line by line)
	local line_num = 0
	for line in io.lines(path) do
		line_num = line_num + 1

		-- Trim whitespace from both ends
		-- ^ = start of string, $ = end of string
		-- %s = whitespace character, + = one or more
		local trimmed = line:match("^%s*(.-)%s*$")

		-- Skip empty lines and comments (lines starting with #)
		if trimmed ~= "" and not trimmed:match("^#") then
			table.insert(commands, {
				line = line_num,
				command = trimmed,
			})
		end
	end

	return commands, root
end

--- Get a specific command (defaults to first/default command)
--- @param index number|nil Which command to get (1-based), defaults to 1
--- @return string|nil command The command string
--- @return string|nil root The project root
function M.get_command(index)
	index = index or 1

	local commands, root = M.get_commands()
	if not commands or #commands == 0 then
		vim.notify("No commands found in .run file", vim.log.levels.WARN)
		return nil, nil
	end

	if index > #commands then
		vim.notify("Command index out of range", vim.log.levels.WARN)
		return nil, nil
	end

	return commands[index].command, root
end

--------------------------------------------------------------------------------
-- TERMINAL EXECUTION
--------------------------------------------------------------------------------

--- Run a command in a split terminal
--- @param command string The command to run
--- @param root string The working directory
local function execute_in_terminal(command, root)
	-- Create a vertical split on the right side
	-- botright = bottom or right of current window
	-- vsplit = vertical split
	vim.cmd("botright vsplit")

	-- Create a new buffer
	-- First arg: listed (false = don't show in :ls)
	-- Second arg: scratch (true = throwaway buffer, no file association)
	local buf = vim.api.nvim_create_buf(false, true)

	-- Put our new buffer in the current window (the split we just created)
	-- 0 = current window
	vim.api.nvim_win_set_buf(0, buf)

	-- Set a nice name for the buffer (shows in statusline)
	vim.api.nvim_buf_set_name(buf, "Runner: " .. command:sub(1, 30))

	-- Start the job with terminal output
	vim.fn.jobstart(command, {
		cwd = root, -- Working directory for the command
		term = true, -- Attach to a terminal (shows output interactively)

		-- Callback when process exits
		on_exit = function(_, exit_code, _)
			-- vim.schedule defers execution to the main event loop
			-- This is REQUIRED because on_exit runs in a "fast" callback context
			-- where you can't safely modify buffers
			vim.schedule(function()
				-- Make buffer writable so we can append text
				vim.api.nvim_set_option_value("modifiable", true, { buf = buf })

				-- Append exit message
				-- -1, -1 means "at the very end"
				vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
					"",
					"─────────────────────────────────────────",
					"Process exited with code " .. exit_code,
					"Press q to close",
				})

				-- Make it read-only again
				vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
			end)
		end,
	})

	local close_window = function()
		vim.api.nvim_win_close(0, true)
	end
	vim.keymap.set("n", "q", close_window, { buffer = buf, silent = true })
	vim.keymap.set("n", "<Esc>", close_window, { buffer = buf, silent = true })

	-- Terminal opens in insert mode by default, switch to normal
	-- so user can see output and scroll
	vim.cmd("stopinsert")
end

--------------------------------------------------------------------------------
-- PUBLIC COMMANDS
--------------------------------------------------------------------------------

--- Run the default (first) command
function M.run()
	local command, root = M.get_command(1)
	if not command or not root then
		return
	end

	vim.notify("Running: " .. command, vim.log.levels.INFO)
	execute_in_terminal(command, root)
end

--- Open a picker to select which command to run
function M.run_select()
	local commands, root = M.get_commands()
	if not commands or #commands == 0 or not root then
		return
	end

	-- If only one command, just run it
	if #commands == 1 then
		M.run()
		return
	end

	-- Build list of display strings for the picker
	-- vim.ui.select is a built-in UI hook that your config can override
	-- (telescope, fzf-lua, etc. often provide nicer implementations)
	local items = {}
	for i, cmd in ipairs(commands) do
		-- Show index and command, mark first as default
		local prefix = i == 1 and "[default] " or ""
		table.insert(items, prefix .. cmd.command)
	end

	vim.ui.select(items, {
		prompt = "Select command to run:",

		-- format_item lets you customize how each item is displayed
		-- (we already formatted above, so just return as-is)
		format_item = function(item)
			return item
		end,
	}, function(_, idx)
		-- choice = the selected string, idx = the index (1-based)
		-- If user cancels (Esc), both are nil
		if not idx then
			return
		end

		local command = commands[idx].command
		vim.notify("Running: " .. command, vim.log.levels.INFO)
		execute_in_terminal(command, root)
	end)
end

--------------------------------------------------------------------------------
-- EDIT WINDOW (Harpoon-style)
--------------------------------------------------------------------------------

--- Open a floating window to edit the .run file directly
function M.edit()
	local path = M.get_run_file_path()

	-- If no .run file exists, create one at the project root
	if not path then
		local root = M.get_root()
		if not root then
			-- No .run file AND we can't find a project root
			-- Fall back to current working directory
			root = vim.fn.getcwd()
		end
		path = root .. "/.run"

		-- Create empty file
		local file = io.open(path, "w")
		if file then
			file:write("# Add commands here (one per line)\n")
			file:write("# First command is the default\n")
			file:write("# Lines starting with # are comments\n")
			file:close()
		end
	end

	-- Calculate window dimensions
	-- vim.o.columns = total editor width
	-- vim.o.lines = total editor height
	local width = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines * 0.4)

	-- Calculate position to center the window
	-- (total - window_size) / 2 gives the offset
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create buffer for the window
	-- We'll load the actual file into this buffer
	local buf = vim.fn.bufadd(path) -- Add buffer for this file path
	vim.fn.bufload(buf) -- Load the buffer contents from disk

	-- Open floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor", -- Position relative to the whole editor
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal", -- No line numbers, etc.
		border = "rounded", -- Nice rounded border
		title = " Runner Commands (q to save & close) ",
		title_pos = "center",
	})

	-- Set some window-local options
	-- These only affect this window, not the buffer globally
	vim.api.nvim_set_option_value("winblend", 0, { win = win }) -- No transparency
	vim.api.nvim_set_option_value("cursorline", true, { win = win }) -- Highlight current line

	-- Keymaps for the edit window
	local opts = { buffer = buf, silent = true }

	-- q = save and close
	vim.keymap.set("n", "q", function()
		vim.cmd("write") -- Save the file
		vim.api.nvim_win_close(win, true) -- Close the window
	end, opts)

	-- Escape = close without saving (discard changes)
	vim.keymap.set("n", "<Esc>", function()
		vim.cmd("edit!") -- Reload from disk, discarding changes
		vim.api.nvim_win_close(win, true)
	end, opts)
end

--------------------------------------------------------------------------------
-- RETURN THE MODULE
--------------------------------------------------------------------------------

-- This table is what you get when you call require("runner")
-- e.g., require("runner").run()
return M
