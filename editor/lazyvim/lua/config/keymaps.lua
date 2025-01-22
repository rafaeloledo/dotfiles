-- help make less motions when pasting
-- can avoid one switching cycle
vim.keymap.set("i", "<C-v>", "<C-r>+")

-- help change numbers im batch with tmux
vim.keymap.set({ "n", "v", "x" }, "+", "<C-a>")
vim.keymap.set({ "n", "v", "x" }, "-", "<C-x>")

-- less keystrokes
-- high usage
vim.keymap.set("n", "<C-c>", ".")

-- if i have on hand or desire to use only one
vim.keymap.set("n", "<Up>", "<c-w>k")
vim.keymap.set("n", "<Down>", "<c-w>j")
vim.keymap.set("n", "<Left>", "<c-w>h")
vim.keymap.set("n", "<Right>", "<c-w>l")
