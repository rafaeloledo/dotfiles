local opts = { silent = true }
local keymap = vim.keymap

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<leader>p", '"0p')
keymap.set("n", "<leader>P", '"0P')
keymap.set("v", "<leader>p", '"0p')
keymap.set("n", "<leader>c", '"_c')
keymap.set("n", "<leader>C", '"_C')
keymap.set("v", "<leader>c", '"_c')
keymap.set("v", "<leader>C", '"_C')
keymap.set("n", "<leader>d", '"_d')
keymap.set("n", "<leader>D", '"_D')
keymap.set("v", "<leader>d", '"_d')
keymap.set("v", "<leader>D", '"_D')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Yank all
keymap.set("n", "ya", "ggVGy")

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit<CR>", { silent = true })
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Personal
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- keymap.set("n", "sf", function()
--   require("mini.files").open()
-- end, { desc = "Mini Files" })

keymap.set("n", "sf", "<cmd>Neotree<CR>", { desc = "Neotree" })
