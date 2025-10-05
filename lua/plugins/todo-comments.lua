return {
	"folke/todo-comments.nvim",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = { signs = false },
	keys = {
		{
			"<leader>ft",
			"<CMD>TodoFzfLua<CR>",
			desc = "Find todo comments",
		},
	},
}
