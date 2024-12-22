vim.keymap.set("n", "<leader>tt", ":Trouble diagnostics toggle<CR>", { silent = true })
vim.keymap.set("n", "<leader>tT", ":Trouble diagnostics toggle filter.buf=0<CR>", { silent = true })
vim.keymap.set("n", "[t", ":Trouble diagnostics previous<CR>", { silent = true })
vim.keymap.set("n", "]t", ":Trouble diagnostics next<CR>", { silent = true })

