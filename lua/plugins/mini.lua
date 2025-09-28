return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.ai").setup()
		-- require("mini.pairs").setup()
		require("mini.surround").setup()
		require("mini.move").setup({
			mappings = {
				down       = "<M-Down>",
                up         = "<M-Up>",
				line_down  = "<M-Down>",
				line_up    = "<M-Up>",
			},
		})

		require("mini.statusline").setup()
        require("mini.align").setup()


		vim.cmd([[highlight StatusLine guibg=NONE ctermbg=NONE]])
		vim.cmd([[highlight StatusLineNC guibg=NONE ctermbg=NONE]])
		vim.cmd([[highlight MiniStatuslineFilename guibg=NONE ctermbg=NONE]])
	end,
}
