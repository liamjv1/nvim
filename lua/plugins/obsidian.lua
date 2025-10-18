return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	enabled = false,
	ft = "markdown",
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},
		workspaces = {
			{
				name = "notes",
				path = "~/Dropbox/personal/notes",
			},
		},
		completion = {
			-- Enables completion using blink.cmp
			blink = true,
			min_chars = 2,
		},
		legacy_commands = false,
		ui = {
			enable = true,
		},
		note_id_func = function(title)
			local suffix = ""

			if title ~= nil then
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end

			return suffix
		end,
		attachments = {
			img_folder = "assets",
		},
	},
	-- keys = {
	-- 	{ "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian: new note" },
	-- },
}
