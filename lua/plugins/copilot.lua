return {
	"zbirenbaum/copilot.lua",
	enabled = false,
	dependencies = {
		{
			"copilotlsp-nvim/copilot-lsp",
			init = function()
				vim.g.copilot_nes_debounce = 500
			end,
		},
	},
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<Tab>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			panel = { enabled = false },
			nes = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<C-l>",
				},
			},
		})
	end,
}
