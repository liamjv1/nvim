-- return {
-- 	"rebelot/kanagawa.nvim",
-- 	config = function()
-- 		require("kanagawa").setup({
-- 			transparent = true,
-- 			colors = {
-- 				theme = {
-- 					all = {
-- 						ui = {
-- 							bg_gutter = "none",
-- 						},
-- 					},
-- 				},
-- 			},
-- 		})
-- 		vim.cmd("colorscheme kanagawa-wave")
-- 	end,
-- }

return {
	"folke/tokyonight.nvim",
	name = "tokyonight",
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "night",
			transparent = true,
			styles = {
                sidebars = "transparent", -- transparent sidebars
                floats = "transparent", -- transparent floats
			},
			on_colors = function(colors)
				colors.bg = "#161A1D"
				colors.bg_dark = "#0f1316"
				colors.bg_sidebar = colors.bg_dark
				colors.bg_float = colors.bg
				colors.fg = "#cfd8e3" -- starlight
				colors.fg_gutter = "#5c6675"
			end,
			on_highlights = function(hl, c)
				hl.LineNr = { fg = c.fg_gutter }
				hl.CursorLine = { bg = "NONE" }
				hl.CursorLineNr = { fg = c.warning, bold = true }
			end,
		})
		vim.cmd("colorscheme tokyonight")
	end,
}
