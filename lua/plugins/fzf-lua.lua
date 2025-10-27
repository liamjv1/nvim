return {
	"ibhagwan/fzf-lua",
	opts = {
		files = {
			file_icons = false,
			cmd = "(rg --files --hidden --glob '!.git' 2>/dev/null; fd --type f --hidden --follow --exclude .git --no-ignore --glob '.env*' 2>/dev/null) | sort -u",
		},
		keymap = {
			fzf = {
				["ctrl-q"] = "select-all+accept",
			},
		},
	},
	keys = {
		{
			"<leader>ff",
			function()
				require("fzf-lua").files()
			end,
			desc = "Find files",
		},
		{
			"<leader>fw",
			function()
				require("fzf-lua").grep_cword()
			end,
			desc = "Find word under cursor",
		},
		{
			"<leader>fg",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "Live grep",
		},
		{
			"<leader>fb",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<leader>fr",
			function()
				require("fzf-lua").oldfiles()
			end,
			desc = "Find recent files",
		},
		{
			"<leader>fk",
			function()
				require("fzf-lua").keymaps()
			end,
			desc = "Find keymaps",
		},
		{
			"<leader>fh",
			function()
				require("fzf-lua").helptags()
			end,
			desc = "Find help",
		},
		{
			"<leader>fd",
			function()
				local fzf = require("fzf-lua")

				local dir_cmd
				if vim.fn.executable("fd") == 1 then
					dir_cmd = "fd --type d --hidden --exclude .git"
				elseif vim.fn.executable("find") == 1 then
					dir_cmd = "find . -type d -not -path '*/.git/*' 2>/dev/null"
				end

				fzf.fzf_exec(dir_cmd, {
					prompt = "Directories❯ ",
					file_icons = false,
					color_icons = false,
					fzf_opts = {
						["--preview"] = "ls -1 {}",
						["--preview-window"] = "right:50%",
					},
					actions = {
						["enter"] = function(selected)
							if selected and selected[1] then
								vim.cmd("Oil " .. vim.fn.fnameescape(selected[1]))
							end
						end,
					},
				})
			end,
			desc = "Find directories",
		},
	},
}
