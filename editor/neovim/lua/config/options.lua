vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true

vim.cmd("colorscheme gruvbox")

-- Better UI
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- Move to the new split window
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.laststatus = 3
vim.opt.list = false

-- Better searching
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Better editing
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.linebreak = true

-- Performance
vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- File handling
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undolevels = 10000

-- Completion
vim.opt.completeopt = "menuone,noselect"

vim.opt.colorcolumn = "80"

vim.opt.guicursor = "a:block-blinkon0"
