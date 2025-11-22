return {
	"mg979/vim-visual-multi",
	branch = "master",
	ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "html" },
	init = function()
		-- Basic keymaps
		vim.g.VM_maps = {
			["Find Under"] = "<C-n>",
			["Find Subword Under"] = "<C-n>",
			["Add Cursor Down"] = false,
			["Add Cursor Up"] = false,
			["Skip Region"] = "q",
			["Remove Region"] = "Q",
		}

		-- Custom motions to use arrow keys instead of hjkl
		-- vim.g.VM_custom_motions = {
		-- 	["<Up>"] = "k",
		-- 	["<Down>"] = "j",
		-- 	["<Left>"] = "h",
		-- 	["<Right>"] = "l",
		-- }
	end,
}
