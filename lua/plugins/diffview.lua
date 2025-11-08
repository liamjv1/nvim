return {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	keys = {
		{ "<leader>co", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
		{ "<leader>cc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
	},
}
