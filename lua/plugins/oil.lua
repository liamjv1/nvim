return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	enabled = true,
	opts = {
		skip_confirm_for_simple_edits = true,
		delete_to_trash = true,
		view_options = {
			show_hidden = true,
		},
		-- Override the default keymaps
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-s>"] = { "actions.select", opts = { vertical = true } },
			["<C-h>"] = false, -- Disable horizontal split (conflicts with window nav)
			["<C-t>"] = { "actions.select", opts = { tab = true } },
			["<C-p>"] = "actions.preview",
			["<C-c>"] = "actions.close",
			["<C-l>"] = false, -- Disable refresh (conflicts with window nav)
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = { "actions.cd", opts = { scope = "tab" } },
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},
		-- Keep defaults enabled but override specific ones above
		use_default_keymaps = true,
	},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
	keys = {
		{
			"-",
			"<CMD>Oil<CR>",
			desc = "Go to parent directory",
		},
	},
}
