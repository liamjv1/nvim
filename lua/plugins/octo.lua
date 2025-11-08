return {
	"pwntester/octo.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		picker = "telescope",
		enable_builtin = true,
	},
	keys = {
		{ "<leader>O", "<cmd>Octo<cr>", desc = "Octo" },
	},
}
