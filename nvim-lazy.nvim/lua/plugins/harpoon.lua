local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>A", function() harpoon:list():prepend() end)
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- I've adjusted this binding in my autohotkey config
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<leader><C-h>", function() harpoon:list():replace_at(1) end)
vim.keymap.set("n", "<leader><C-t>", function() harpoon:list():replace_at(2) end)
vim.keymap.set("n", "<leader><C-n>", function() harpoon:list():replace_at(3) end)
vim.keymap.set("n", "<leader><C-s>", function() harpoon:list():replace_at(4) end)
