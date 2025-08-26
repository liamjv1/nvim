return {
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Allow per-buffer toggle via b:disable_autoformat
			if vim.b[bufnr].disable_autoformat then
				return nil
			end
			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end
		end,
		-- Add a small setup to define a user command
		init = function()
			vim.api.nvim_create_user_command("FormatOnSaveToggle", function()
				vim.b.disable_autoformat = not vim.b.disable_autoformat
				if vim.b.disable_autoformat then
					vim.notify("Format on save: OFF (buffer)", vim.log.levels.INFO)
				else
					vim.notify("Format on save: ON (buffer)", vim.log.levels.INFO)
				end
			end, { desc = "Toggle format-on-save for current buffer" })
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			typescript = { "biome-check" },
			typescriptreact = { "biome-check" },
			css = { "biome-check" },
			html = { "prettierd" },
			json = { "biome-check" },
			markdown = { "prettierd" },
			c = { "clang-format" },
			cpp = { "clang-format" },
		},
		-- stylua: ignore
	},
	keys = {
		{
			"<leader>uf",
			function()
				vim.b.disable_autoformat = not vim.b.disable_autoformat
				if vim.b.disable_autoformat then
					vim.notify("Format on save: OFF (buffer)", vim.log.levels.INFO)
				else
					vim.notify("Format on save: ON (buffer)", vim.log.levels.INFO)
				end
			end,
			desc = "Toggle format-on-save (buffer)",
		},
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			desc = "Format buffer",
		},
	},
}
