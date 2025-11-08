local map = vim.keymap.set

map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })

map("n", "<C-y>", function()
	vim.cmd("normal! ggVG")
	vim.cmd('normal! "+y')
end, { desc = "Copy entire file to system clipboard" })

map("i", "<C-n>", function()
	vim.lsp.completion.get()
end)

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map({ "n", "v" }, "x", '"_x', { desc = "Delete char (no yank)" })

map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search (centered)" })

map("v", "p", '"_dP', { desc = "Paste (no yank)" })
map("n", "gl", vim.diagnostic.open_float, { desc = "Open diagnostic float" })

map("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic" })

map("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic" })

map("n", "<leader>ql", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
map("n", "<leader>qx", "<cmd>cclose<cr>", { desc = "Close quickfix list" })

local function smart_tmux_nav(dir)
	local v = { Up = "k", Down = "j", Left = "h", Right = "l" }
	local t = { Up = "U", Down = "D", Left = "L", Right = "R" }

	local before = vim.fn.winnr()
	vim.cmd("wincmd " .. v[dir])

	if vim.fn.winnr() == before then
		if vim.env.TMUX and #vim.env.TMUX > 0 then
			vim.fn.system({ "tmux", "select-pane", "-" .. t[dir] })
		end
	end
end

local opts = { silent = true }

map("n", "<C-w><Up>", function()
	smart_tmux_nav("Up")
end, opts)
map("n", "<C-w><Down>", function()
	smart_tmux_nav("Down")
end, opts)
map("n", "<C-w><Left>", function()
	smart_tmux_nav("Left")
end, opts)
map("n", "<C-w><Right>", function()
	smart_tmux_nav("Right")
end, opts)

map("n", "<C-w>k", function()
	smart_tmux_nav("Up")
end, opts)
map("n", "<C-w>j", function()
	smart_tmux_nav("Down")
end, opts)
map("n", "<C-w>h", function()
	smart_tmux_nav("Left")
end, opts)
map("n", "<C-w>l", function()
	smart_tmux_nav("Right")
end, opts)
