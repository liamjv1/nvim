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

-- map("n", "<leader>ql", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
-- map("n", "<leader>qx", "<cmd>cclose<cr>", { desc = "Close quickfix list" })

-- never use Tab to jump forward in jump list anyways, always use <C-i>
map("n", "<Tab>", "gt")
map("n", "<S-Tab>", "gT")

map("v", "<M-up>", ":m '<-2<CR>gv=gv")
map("v", "<M-down>", ":m '>+1<CR>gv=gv")
