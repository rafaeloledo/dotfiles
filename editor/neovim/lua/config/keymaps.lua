local keymap = vim.keymap

keymap.set("n", "sf", "<cmd>Oil<CR>")
-- keymap.set("n", "sf", vim.cmd.Ex)

keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<CR>")

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
keymap.set("i", "<C-v>", "<C-r>+", { desc = "Paste from clipboard" })

keymap.set({ "n", "v", "x" }, "+", "<C-a>", { desc = "Increment" })
keymap.set({ "n", "v", "x" }, "-", "<C-x>", { desc = "Decrement" })

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

keymap.set("n", "=ap", "ma=ap'a")

keymap.set("n", "<leader>f", function()
	require("conform").format()
end)

vim.keymap.set("n", "<leader>r", function()
  require("craftzdog.hsl").replaceHexWithHSL()
end)

vim.keymap.set("n", "<leader>i", function()
  require("craftzdog.lsp").toggleInlayHints()
end)

vim.api.nvim_create_user_command("ToggleAutoformat", function()
  require("craftzdog.lsp").toggleAutoformat()
end, {})

local vscode = require("config.vscode")

if vscode.is_vscode() then
  vim.keymap.set("n", "<leader><space>", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")
  vim.keymap.set("n", "<leader>sr", "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>")
  vim.keymap.set("n", "<C-w>v", "<Cmd>call VSCodeNotify('workbench.action.splitEditor')<CR>")
  vim.keymap.set("n", "<C-w>s", "<Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>")
end

keymap.set("n", "<C-t>", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap.set("n", "<C-c>", "<cmd>tabclose<CR>", { desc = "Tab Close" })
keymap.set("n", "<S-l>", ":tabnext<CR>", { desc = "Tab Next", silent = true })
keymap.set("n", "<S-h>", ":tabprevious<CR>", { desc = "Tab Previous", silent = true })
