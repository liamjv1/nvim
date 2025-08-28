return {
	"mg979/vim-visual-multi",
	branch = "master",
	enabled = false,
	config = function()
		vim.g.VM_maps = {
			-- Basic multicursor
			["Find Under"] = "<C-n>",
			["Find Subword Under"] = "<C-n>",
			["Select All"] = "<C-A-n>",
			["Skip Region"] = "<C-x>",
			["Remove Region"] = "<C-p>",

			["Switch Mode"] = "<Tab>",
			["Exit"] = "<Esc>",
		}

		vim.g.VM_theme = "iceblue"
		vim.g.VM_highlight_matches = "underline"
	end,
}
