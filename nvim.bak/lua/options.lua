--- Neovide
vim.g.neovide_scale_factor = 1
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
vim.g.neovide_transparency = 1
vim.g.neovide_position_animation_length = 0
vim.g.neovide_scroll_animation_length = 0
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_refresh_rate = 144
vim.g.neovide_fullscreen = false
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_antialiasing = true
-- https://github.com/ryanoasis/nerd-fonts/releases
vim.o.guifont = "RobotoMono Nerd Font:h14"
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = true
---

vim.cmd("colorscheme catppuccin")
vim.cmd("set clipboard+=unnamed,unnamedplus")
vim.o.hlsearch = true
vim.wo.number = true
vim.o.relativenumber = true
vim.o.undofile = true
vim.o.ignorecase = true

vim.o.conceallevel = 2
vim.o.completeopt = 'menuone,noselect'
vim.wo.signcolumn = 'number'
vim.o.updatetime = 250

vim.opt.swapfile = false

vim.cmd('set shada="NONE"')
vim.cmd('set nowrap')
vim.opt.fillchars = { eob = " " }

vim.cmd('set fileformats=unix,dos')

vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.formatoptions:append({ "r" })

vim.cmd("set nolist")

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.cmdheight = 0
