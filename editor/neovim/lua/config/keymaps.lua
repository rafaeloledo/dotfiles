local set = vim.keymap.set

set({ "n", "v", "x" }, "+", "<C-x>")
set({ "n", "v", "x" }, "-", "<C-a>")

set("n", ">", ">>")
set("n", "<", "<<")
set("n", "=ap", "ma=ap'a")

set("n", "cw", "ciw")
set("n", "vw", "viw")

set('n', '<ScrollWheelUp>', '<C-Y>', { noremap = true, silent = true })
set('n', '<ScrollWheelDown>', '<C-E>', { noremap = true, silent = true })

set({ "n", "i" }, "<C-s>", "<cmd>w<CR><Esc>")
set("n", "<Esc>", "<cmd>nohlsearch<CR>")
set("i", "<C-v>", "<C-r>+")

set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

set("n", "<S-l>", "<cmd>bn<CR>")
set("n", "<S-h>", "<cmd>bp<CR>")
set("n", "<leader>bd", "<cmd>bd<CR>")

set("n", "<M-j>", "<cmd>cnext<cr>")
set("n", "<M-k>", "<cmd>cprevious<cr>")

set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")
set("t", "<M-q>", "<C-\\><C-n>")
set("n", "-", "<cmd>Oil<CR>")

function OpenNautilus(path)
  local target = path or vim.fn.getcwd()
  vim.fn.jobstart({ "nautilus", target }, {
    detach = true,
    on_exit = function() end,
  })
end

set("n", "<leader>o", function()
  OpenNautilus()
end)

set("n", "<leader>qs", function()
  require("persistence").load()
end)

set("n", "<leader>qS", function()
  require("persistence").select()
end)

set("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end)

set("n", "<leader>cf", function()
  require("conform").format()
end)
