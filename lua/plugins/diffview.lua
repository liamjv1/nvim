return {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" }, -- loads when you run these commands
	keys = {
		{ "<leader>co", "<cmd>DiffviewOpen<cr>", desc = "Open diffview (index)" },
		{ "<leader>cc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
		{ "<leader>cd", "<cmd>DiffviewOpen development<cr>", desc = "Diff against development" },
		{ "<leader>cm", "<cmd>DiffviewOpen main<cr>", desc = "Diff against main" },
		{ "<leader>ch", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
	},
	opts = {
		view = {
			default = {
				layout = "diff2_horizontal",
			},
		},
	},
}
