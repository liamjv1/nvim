return {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" }, -- loads when you run these commands
	keys = {
		{ "<leader>co", "<cmd>DiffviewOpen<cr>", desc = "Open diffview (index)" },
		{ "<leader>cc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
		{
			"<leader>cb",
			function()
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")
				require("telescope.builtin").git_branches({
					attach_mappings = function(prompt_bufnr)
						actions.select_default:replace(function()
							actions.close(prompt_bufnr)
							local selection = action_state.get_selected_entry()
							if selection then
								vim.cmd("DiffviewOpen " .. selection.value)
							end
						end)
						return true
					end,
				})
			end,
			desc = "Diff against branch (pick)",
		},
		{ "<leader>ch", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
	},
	opts = {
		view = {
			default = {
				layout = "diff2_horizontal",
			},
		},
	},
}
