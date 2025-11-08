return {
	"folke/todo-comments.nvim",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = { signs = false },
	keys = {
		{
			"<leader>ft",
			"<CMD>TodoTelescope<CR>",
			desc = "Find todo comments",
		},
	},
}
