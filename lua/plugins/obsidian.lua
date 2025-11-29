-- lua/plugins/notes.lua
return {
	{
		"epwalsh/obsidian.nvim",
		ft = "markdown",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			workspaces = { { name = "notes", path = "~/notes" } },
			daily_notes = { folder = "daily" },
			ui = { enable = false },
		},
		keys = {
			{ "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find note" },
			{ "<leader>nn", "<cmd>ObsidianNew<cr>", desc = "New note" },
			{ "<leader>nt", "<cmd>ObsidianToday<cr>", desc = "Today's note" },
			{ "<leader>ns", "<cmd>ObsidianSearch<cr>", desc = "Search in notes" },
		},
	},
}
