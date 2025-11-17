return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	enabled = false,
	dependencies = {
		"copilotlsp-nvim/copilot-lsp",
	},
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					accept = "<C-l>", -- Accept with Ctrl+L
					accept_word = false,
					accept_line = false,
					next = "<M-]>", -- Next suggestion (Alt+])
					prev = "<M-[>", -- Previous suggestion (Alt+[)
					dismiss = "<C-]>", -- Dismiss suggestion
				},
			},
			nes = {
				enabled = false,
			},
		})
	end,
}
