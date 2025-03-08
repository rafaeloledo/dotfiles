vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- LazyVim
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Paste directlu with C-v in insert mode
-- For me, there's no reason to user C-S-v instead
vim.keymap.set("i", "<C-V>", "<C-r>+")

-- Ctrl-z is a useful keymap
-- But it's in a non ergonomic key
vim.keymap.set("n", "<C-q>", "<C-z>")
vim.keymap.set("n", "<C-z>", "<nop>")

-- Mitchell Hashimoto
vim.keymap.set("n", "<C-t>", ":tabedit<CR>")
vim.keymap.set("n", "<C-c>", ":tabclose<CR>")

-- craftzdog (Takuya Matsuyama)
vim.keymap.set({"n", "v", "x"}, "+", "<C-a>")
vim.keymap.set({"n", "v", "x"}, "-", "<C-x>")
