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
