local ts_inlay_hints = {
	includeInlayParameterNameHints = "all",
	includeInlayParameterNameHintsWhenArgumentMatchesName = true,
	includeInlayFunctionParameterTypeHints = true,
	includeInlayVariableTypeHints = true,
	includeInlayVariableTypeHintsWhenTypeMatchesName = true,
	includeInlayPropertyDeclarationTypeHints = true,
	includeInlayFunctionLikeReturnTypeHints = true,
	includeInlayEnumMemberValueHints = true,
}

return {
	settings = {
		typescript = {
			inlayHints = ts_inlay_hints,
		},
		javascript = {
			inlayHints = ts_inlay_hints,
		},
		-- on_attach = function(client, bufnr)
		-- 	require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
		-- end,
	},
}
