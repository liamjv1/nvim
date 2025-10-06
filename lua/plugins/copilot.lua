-- Description: Configuration for GitHub Copilot with Blink completion.
return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	build = ":Copilot auth",
	config = function()
		require("copilot").setup({
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<C-l>", -- We use blink
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-e>",
				},
			},
			panel = {
				enabled = false,
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

		-- Blink setup
		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuOpen",
			callback = function()
				vim.b.copilot_suggestion_hidden = true
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuClose",
			callback = function()
				vim.b.copilot_suggestion_hidden = false
			end,
		})
	end,
}
