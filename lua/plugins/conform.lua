return {
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
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
	},
}
