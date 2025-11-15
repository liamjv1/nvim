return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.ai").setup()
		-- require("mini.pairs").setup()
		require("mini.surround").setup()

		require("mini.statusline").setup()
		require("mini.align").setup()

		vim.cmd([[highlight StatusLine guibg=NONE ctermbg=NONE]])
		vim.cmd([[highlight StatusLineNC guibg=NONE ctermbg=NONE]])
		vim.cmd([[highlight MiniStatuslineFilename guibg=NONE ctermbg=NONE]])
	end,
}
