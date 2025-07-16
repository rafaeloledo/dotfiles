vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.scrolloff = 10
vim.o.clipboard = "unnamed,unnamedplus"
vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true

vim.o.termguicolors = true
vim.o.signcolumn = "yes"

vim.o.splitbelow = true
vim.o.splitright = true
vim.o.laststatus = 3
vim.o.list = false

vim.o.hlsearch = true
vim.o.incsearch = true

vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false

vim.o.fileformat = "unix"

vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>")

vim.cmd('source ~/.config/nvim/colors.vim')
