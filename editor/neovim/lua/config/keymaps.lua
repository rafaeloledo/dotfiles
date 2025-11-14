local keymap = vim.keymap

keymap.set({ "n", "v", "x" }, "+", "<C-a>")
keymap.set({ "n", "v", "x" }, "-", "<C-x>")
keymap.set("n", ">", ">>")
keymap.set("n", "<", "<<")
keymap.set("n", "=ap", "ma=ap'a")

keymap.set("n", "<C-_>", function()
  prine("You pressed Ctrl-/")
end, { noremap = true, silent = true })


keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<CR><Esc>")
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap.set("i", "<C-v>", "<C-r>+")

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

keymap.set("n", "<S-l>", "<cmd>bn<CR>")
keymap.set("n", "<S-h>", "<cmd>bp<CR>")
keymap.set("n", "<C-c>", "<cmd>bd<cr>")

keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sl", "<C-w>l")
keymap.set("n", "sv", "<C-w>v")
keymap.set("n", "ss", "<C-w>s")

keymap.set("n", "<M-j>", "<cmd>cnext<cr>")
keymap.set("n", "<M-k>", "<cmd>cprevious<cr>")



keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")
keymap.set("t", "<M-q>", "<C-\\><C-n>")
keymap.set("n", "-", "<cmd>Oil<CR>")
-- keymap.set("n", "<leader>fe", "<cmd>Neotree toggle<CR>")



keymap.set("n", "<leader>o", function()
  OpenNautilus()
end)

function OpenNautilus(path)
  local target = path or vim.fn.getcwd()
  vim.fn.jobstart({ "nautilus", target }, {
    detach = true,
    on_exit = function() end,
  })
end



keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end)

keymap.set("n", "<leader>qS", function()
  require("persistence").select()
end)

keymap.set("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end)



keymap.set("n", "<leader>cf", function()
  require("conform").format()
end)
