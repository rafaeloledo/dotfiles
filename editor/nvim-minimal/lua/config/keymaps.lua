local set = vim.keymap.set

set({ "n" }, "<C-a>", "ggVGy")

set({ "n", "v", "x" }, "+", "<C-x>")
set({ "n", "v", "x" }, "-", "<C-a>")

set({ "n", "i" }, "<C-s>", "<cmd>w<CR><Esc>")

set("n", "<Esc>", "<cmd>nohlsearch<CR>")

set("i", "<C-v>", "<C-r>+")

set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

set("n", "<M-j>", "<cmd>cnext<cr>")
set("n", "<M-k>", "<cmd>cprevious<cr>")

set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")
set("n", "-", "<cmd>Oil<CR>")

-- LazyVim
set("n", "<S-l>", "<cmd>bn<CR>")
set("n", "<S-h>", "<cmd>bp<CR>")
set("n", "<leader>bd", "<cmd>bd<CR>")
set("t", "<M-q>", "<C-\\><C-n>")