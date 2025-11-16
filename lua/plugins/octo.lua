return {
	"pwntester/octo.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		enable_builtin = true,
		picker = "telescope",
		default_to_projects_v2 = true,
		default_merge_method = "squash",
	},
	keys = {
		{ "<leader>O", "<cmd>Octo<cr>", desc = "Octo" },
		{ "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List Issues (Octo)" },
		{ "<leader>gI", "<cmd>Octo issue search<CR>", desc = "Search Issues (Octo)" },
		{ "<leader>gp", "<cmd>Octo pr list<CR>", desc = "List PRs (Octo)" },
		{ "<leader>gP", "<cmd>Octo pr search<CR>", desc = "Search PRs (Octo)" },
		{ "<leader>gr", "<cmd>Octo repo list<CR>", desc = "List Repos (Octo)" },
		{ "<leader>gS", "<cmd>Octo search<CR>", desc = "Search (Octo)" },
	},
}
