return {
	"mbbill/undotree",
	config = function()
		vim.g.undotree_WindowLayout = 3
		vim.g.undotree_SetFocusWhenToggle = 1
		vim.g.undotree_ShortIndicators = 1
		vim.g.undotree_DiffpanelHeight = 10
		vim.g.undotree_SplitWidth = 24
	end,
	keys = {
		{ "<leader>u", "<CMD>UndotreeToggle<CR>", desc = "Toggle undo tree" },
	},
}
