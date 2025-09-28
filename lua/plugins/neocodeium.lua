return {
	"monkoose/neocodeium",
	event = "VeryLazy",
	config = function()
		local neocodeium = require("neocodeium")
		neocodeium.setup()
		vim.keymap.set("i", "<M-n>", neocodeium.accept)
		vim.keymap.set("i", "<M-Right>", function()
			neocodeium.cycle(1)
		end)
		vim.keymap.set("i", "<M-Left>", function()
			neocodeium.cycle(-1)
		end)
	end,
}
