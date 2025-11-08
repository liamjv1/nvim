return {
	"christoomey/vim-tmux-navigator",
	event = "VeryLazy",
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
		"TmuxNavigatorProcessList",
	},
	keys = {
		{ "<c-left>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
		{ "<c-down>", "<cmd><C-U>TmuxNavigateDown<cr>" },
		{ "<c-up", "<cmd><C-U>TmuxNavigateUp<cr>" },
		{ "<c-right>", "<cmd><C-U>TmuxNavigateRight<cr>" },
		{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
	},
}
