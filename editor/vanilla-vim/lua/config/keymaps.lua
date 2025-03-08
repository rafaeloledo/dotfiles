local keymap = vim.keymap

keymap.set("n", "<leader>pv", vim.cmd.Ex)

keymap.set("n", "<leader>e", "<cmd>Oil<CR>")

keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<CR>")

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
keymap.set("i", "<C-v>", "<C-r>+", { desc = "Paste from clipboard" })

keymap.set({ "n", "v", "x" }, "+", "<C-a>", { desc = "Increment" })
keymap.set({ "n", "v", "x" }, "-", "<C-x>", { desc = "Decrement" })

keymap.set("n", "<leader>ac", "<cmd>CopilotChat<CR>", { desc = "Copilot Chat" })
keymap.set("v", "<leader>ac", "<cmd>CopilotChatVisual<CR>", { desc = "Chat with selection" })
keymap.set("n", "<leader>ae", "<cmd>CopilotChatExplain<CR>", { desc = "Explain code" })
keymap.set("n", "<leader>at", "<cmd>CopilotChatTests<CR>", { desc = "Generate tests" })
keymap.set("n", "<leader>ar", "<cmd>CopilotChatReview<CR>", { desc = "Review code" })
keymap.set("n", "<leader>af", "<cmd>CopilotChatFix<CR>", { desc = "Fix code" })

local harpoon = require("harpoon")

keymap.set("n", "<leader>h", function()
	harpoon:list():add()
end)
keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

keymap.set("n", "<C-h>", function()
	harpoon:list():select(1)
end)
keymap.set("n", "<C-j>", function()
	harpoon:list():select(2)
end)
keymap.set("n", "<C-k>", function()
	harpoon:list():select(3)
end)
keymap.set("n", "<C-l>", function()
	harpoon:list():select(4)
end)

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

keymap.set("n", "=ap", "ma=ap'a")

keymap.set("n", "<leader>f", function()
	require("conform").format()
end)

-- keymap.set("n", "<leader>f", vim.lsp.buf.format)
