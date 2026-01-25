return {

	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	keys = {
		{
			"<C-p>",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = function()
		local function has_config(patterns)
			local root = vim.fn.getcwd()
			for _, pattern in ipairs(patterns) do
				if vim.fn.glob(root .. "/" .. pattern) ~= "" then
					return true
				end
			end
			return false
		end

		local prettier_configs = {
			".prettierrc",
			".prettierrc.json",
			".prettierrc.yml",
			".prettierrc.yaml",
			".prettierrc.json5",
			".prettierrc.js",
			".prettierrc.cjs",
			".prettierrc.mjs",
			".prettierrc.toml",
			"prettier.config.js",
			"prettier.config.cjs",
			"prettier.config.mjs",
		}

		local biome_configs = {
			"biome.json",
			"biome.jsonc",
		}

		local function get_js_formatters()
			if has_config(biome_configs) then
				return { "biome-check" }
			elseif has_config(prettier_configs) then
				return { "prettierd" }
			else
				return { "prettierd", "biome-check", stop_after_first = true }
			end
		end

		return {
			formatters = {
				["clang-format"] = {
					prepend_args = { "--style={BasedOnStyle: LLVM, IndentWidth: 4}" },
				},
			},
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
				typescript = get_js_formatters(),
				typescriptreact = get_js_formatters(),
				javascript = get_js_formatters(),
				javascriptreact = get_js_formatters(),
				css = get_js_formatters(),
				html = { "prettierd" },
				json = get_js_formatters(),
				markdown = { "prettierd" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},
		}
	end,
}
