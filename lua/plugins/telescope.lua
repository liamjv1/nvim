return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim", "folke/todo-comments.nvim" },
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "Telescope: Find files",
		},
		{
			"<leader>ft",
			"<CMD>TodoTelescope<CR>",
			desc = "Telescope: Find todo",
		},
		{
			"<leader>fw",
			function()
				require("telescope.builtin").grep_string()
			end,
			desc = "Telescope: Find word",
		},

		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Telescope: Live grep",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Telescope: Find buffers",
		},
		{
			"<leader>fr",
			function()
				require("telescope.builtin").oldfiles()
			end,
			desc = "Telescope: Find recent files",
		},
		{
			"<leader>fk",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "Telescope: Find keymaps",
		},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Telescope: Find help",
		},

		-- For finding directories and opening with oil
		{
			"<leader>fd",
			function()
				local pickers = require("telescope.pickers")
				local finders = require("telescope.finders")
				local conf = require("telescope.config").values
				local previewers = require("telescope.previewers")
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")

				local dir_cmd
				if vim.fn.executable("fd") == 1 then
					dir_cmd = { "fd", "--type", "d", "--hidden", "--exclude", ".git" }
				elseif vim.fn.executable("rg") == 1 then
					dir_cmd = { "rg", "--hidden", "--glob", "!.git", "--color", "never", "--only-matching", "-n", "^", "-g", "*/" }
				else
					dir_cmd = { "sh", "-c", "find . -type d -not -path '*/.git/*'" }
				end

				-- Buffer previewer driven by libuv; no external processes
				local previewer = previewers.new_buffer_previewer({
					title = "Contents",
					define_preview = function(self, entry)
						local function to_abs(p)
							if not p or p == "" then return nil end
							if p:sub(1, 1) == "/" then return p end
							return vim.fn.fnamemodify(p, ":p")
						end
						local dir = to_abs(entry[1])
						local bufnr = self.state.bufnr
						vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Loading…" })

						local uv = vim.loop
						local items = {}
						local function scandir(path)
							local req = uv.fs_scandir(path)
							if not req then return end
							while true do
								local name, t = uv.fs_scandir_next(req)
								if not name then break end
								if name ~= "." and name ~= ".." then
									local suffix = (t == "directory") and "/" or ""
									table.insert(items, name .. suffix)
								end
							end
						end

						if dir then
							pcall(scandir, dir)
						else
							items = { "No directory selected" }
						end

						if #items == 0 then items = { "(empty)" } end
						table.sort(items, function(a, b)
							local ad, bd = a:sub(-1) == "/", b:sub(-1) == "/"
							if ad ~= bd then return ad end
							return a:lower() < b:lower()
						end)

						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, items)
						vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
					end,
				})

				pickers
					.new({}, {
						prompt_title = "Directories",
						-- Always search from project root (or current working directory at start)
						finder = finders.new_oneshot_job(dir_cmd, { cwd = vim.fn.getcwd(-1, -1) }),
						sorter = conf.generic_sorter({}),
						previewer = previewer,
						attach_mappings = function(_, map)
							local open = function(buf)
								local entry = action_state.get_selected_entry()
								actions.close(buf)
								if not entry or not entry[1] then return end
								local dir = entry[1]
								if dir:sub(1, 1) ~= "/" then
									dir = vim.fn.fnamemodify(dir, ":p")
								end
							-- Open Oil at the selected path without permanently changing future picker scope
							vim.cmd("keepalt Oil " .. vim.fn.fnameescape(dir))

							end
							map("i", "<CR>", open)
							map("n", "<CR>", open)
							return true
						end,
					})
					:find()
			end,
			desc = "Telescope: Find directories",
		},
	},
}
