return {
	"pwntester/octo.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ibhagwan/fzf-lua",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		picker = "fzf-lua",
		enable_builtin = true,
	},
	keys = {
		{ "<leader>O", "<cmd>Octo<cr>", desc = "Octo" },
	},
}
