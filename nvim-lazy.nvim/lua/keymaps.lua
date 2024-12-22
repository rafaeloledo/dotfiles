-- while in normal mode and not in visual
vim.keymap.set("n", "H", "^", { silent = true })
vim.keymap.set("n", "L", "$", { silent = true })

-- resize window view directly with , and . instead of shift + them
vim.keymap.set("n", "<C-w>,", ":vertical resize -10<CR>", { silent = true })
vim.keymap.set("n", "<C-w>.", ":vertical resize +10<CR>", { silent = true })

-- reload config doom emacs style
vim.keymap.set("n", "<leader>hrr", ":silent !home-manager switch --flake /mnt/share/.dotfiles/nix --impure 1>/dev/null 2>&1 <cr>", { silent = true })

vim.keymap.set("n", "<leader>cd", function ()
	vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
end)

vim.keymap.set("n", "te", ":tabedit<CR>", { silent = true })

vim.keymap.set("n", "<C-a>", "ggVG")
