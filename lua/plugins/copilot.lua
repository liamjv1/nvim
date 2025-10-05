return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = {
				-- set to true to enable auto-triggering of completions
				auto_trigger = true,
				-- set to false if you want copilot to keep suggesting while cmp is open
				hide_during_completion = false,
				-- keymaps for interacting with completions
				keymap = {
					accept = "<C-l>", -- A different key to accept, to avoid conflicts
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-e>",
				},
			},
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					open = "<M-CR>",
				},
			},
		})

		vim.keymap.set("i", "<C-l>", function()
			require("copilot.suggestion").accept()
		end, { desc = "Accept copilot suggestion" })
	end,
}
