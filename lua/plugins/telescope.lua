return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.9",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<C-q>"] = require("telescope.actions").send_selected_to_qflist
							+ require("telescope.actions").open_qflist,
					},
					n = {
						["<C-q>"] = require("telescope.actions").send_selected_to_qflist
							+ require("telescope.actions").open_qflist,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
			},
		})
		pcall(telescope.load_extension, "fzf")
	end,
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "Find files",
		},
		{
			"<leader>fw",
			function()
				require("telescope.builtin").grep_string()
			end,
			desc = "Find word under cursor",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Live grep",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<leader>fr",
			function()
				require("telescope.builtin").oldfiles()
			end,
			desc = "Find recent files",
		},
		{
			"<leader>fk",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "Find keymaps",
		},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Find help",
		},
		{
			"<leader>fd",
			function()
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")
				local pickers = require("telescope.pickers")
				local finders = require("telescope.finders")
				local conf = require("telescope.config").values
				local previewers = require("telescope.previewers")

				local dir_cmd
				if vim.fn.executable("fd") == 1 then
					dir_cmd = { "fd", "--type", "d", "--hidden", "--exclude", ".git" }
				else
					dir_cmd = { "find", ".", "-type", "d", "-not", "-path", "*/.git/*" }
				end

				pickers
					.new({}, {
						prompt_title = "Directories",
						finder = finders.new_oneshot_job(dir_cmd, {}),
						sorter = conf.generic_sorter({}),
						previewer = previewers.new_buffer_previewer({
							title = "Directory Contents",
							define_preview = function(self, entry)
								local output = vim.fn.systemlist("ls -1 " .. vim.fn.shellescape(entry.value))
								vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, output)
							end,
						}),
						attach_mappings = function(prompt_bufnr)
							actions.select_default:replace(function()
								local selection = action_state.get_selected_entry()
								actions.close(prompt_bufnr)
								if selection then
									vim.cmd("Oil " .. vim.fn.fnameescape(selection.value))
								end
							end)
							return true
						end,
					})
					:find()
			end,
			desc = "Find directories",
		},
	},
}
