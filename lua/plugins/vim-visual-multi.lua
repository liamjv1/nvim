return {
	"mg979/vim-visual-multi",
	branch = "master",
	config = function()
		vim.g.VM_maps = {
			-- Basic multicursor
			["Find Under"] = "<C-n>",
			["Find Subword Under"] = "<C-n>",
			["Select All"] = "<C-A-n>",
			["Skip Region"] = "<C-x>",
			["Remove Region"] = "<C-p>",

			-- Now you can use these without conflicts!
			["Add Cursor Down"] = "<C-Down>",
			["Add Cursor Up"] = "<C-Up>",
			["Select Right"] = "<S-Right>",
			["Select Left"] = "<S-Left>",

			["Switch Mode"] = "<Tab>",
			["Exit"] = "<Esc>",
		}

		vim.g.VM_theme = "iceblue"
		vim.g.VM_highlight_matches = "underline"
	end,
}
