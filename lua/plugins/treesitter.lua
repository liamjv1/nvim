return {
	{ "nvim-treesitter/nvim-treesitter-context", opts = {
		max_lines = 2,
	} },
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"windwp/nvim-ts-autotag",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"html",
					"yaml",
					"javascript",
					"typescript",
					"tsx",
					"vue",
					"svelte",
					"css",
					"rust",
					"go",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,

					disable = function(_, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,

					additional_vim_regex_highlighting = false,
				},
				textobjects = {
					select = {
						enable = true, -- TURN THIS ON, NOT OFF
						lookahead = true, -- Automatically jump forward to matching textobject
						keymaps = {
							["af"] = "@function.outer", -- Select around function
							["if"] = "@function.inner", -- Select inside function
							["ac"] = "@class.outer", -- Select around class
							["ic"] = "@class.inner", -- Select inside class
							["aa"] = "@parameter.outer", -- Select around parameter/argument
							["ia"] = "@parameter.inner", -- Select inside parameter/argument
							["ab"] = "@block.outer", -- Select around block
							["ib"] = "@block.inner", -- Select inside block
							["al"] = "@loop.outer", -- Select around loop
							["il"] = "@loop.inner", -- Select inside loop
							["ai"] = "@conditional.outer", -- Select around conditional
							["ii"] = "@conditional.inner", -- Select inside conditional
							["aC"] = "@comment.outer", -- Select around comment
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
							["]a"] = "@parameter.outer",
							["]i"] = "@conditional.outer",
							["]l"] = "@loop.outer",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]C"] = "@class.outer",
							["]A"] = "@parameter.outer",
							["]I"] = "@conditional.outer",
							["]L"] = "@loop.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
							["[a"] = "@parameter.outer",
							["[i"] = "@conditional.outer",
							["[l"] = "@loop.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[C"] = "@class.outer",
							["[A"] = "@parameter.outer",
							["[I"] = "@conditional.outer",
							["[L"] = "@loop.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>sa"] = "@parameter.inner", -- Swap current parameter with next
						},
						swap_previous = {
							["<leader>sA"] = "@parameter.inner", -- Swap current parameter with previous
						},
					},
				},
			})

			-- Repeat movement with ; and ,
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
		end,
	},
}
