local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("general", { clear = true })

-- Highlights yanked
autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Makes help windows auto go to right instead of small window below
autocmd("BufWinEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "help" then
			vim.cmd("wincmd L")
		end
	end,
})

autocmd("FileType", {
	pattern = "*",
	callback = function()
		-- Disable comment on new line
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	group = general,
	desc = "Disable New Line Comment",
})

-- Some auto abbreviations
vim.cmd([[
  " Fix accidental capitals on the command-line
  cnoreabbrev <expr> W    (getcmdtype() ==# ':' ? 'w'    : 'W')
  cnoreabbrev <expr> Q    (getcmdtype() ==# ':' ? 'q'    : 'Q')
  cnoreabbrev <expr> Wq   (getcmdtype() ==# ':' ? 'wq'   : 'Wq')
  cnoreabbrev <expr> Wqa  (getcmdtype() ==# ':' ? 'wqa'  : 'Wqa')

  " This fixes when typing too fast my nav layer is still active when i press q my shift for : is still active mea
  cnoreabbrev < w
  cnoreabbrev ` q
  cnoreabbrev <q wq
]])
