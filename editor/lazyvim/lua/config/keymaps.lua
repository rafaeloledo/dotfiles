local vscode = require("config.vscode")

-- Keymaps compartilhados entre Neovim padrão e VSCode-Neovim
vim.keymap.set("i", "<C-v>", "<C-r>+")
vim.keymap.set({ "n", "v", "x" }, "+", "<C-a>")
vim.keymap.set({ "n", "v", "x" }, "-", "<C-x>")

-- Keymaps apenas para Neovim standalone
if not vscode.is_vscode() then
  vim.keymap.set("n", "<C-c>", ".")
  
  vim.keymap.set("n", "<leader>r", function()
    require("craftzdog.hsl").replaceHexWithHSL()
  end)
  
  vim.keymap.set("n", "<leader>i", function()
    require("craftzdog.lsp").toggleInlayHints()
  end)
  
  vim.api.nvim_create_user_command("ToggleAutoformat", function()
    require("craftzdog.lsp").toggleAutoformat()
  end, {})
end

-- Keymaps específicos para VSCode-Neovim
if vscode.is_vscode() then
  -- Exemplos de keymaps integrados ao VSCode
  vim.keymap.set("n", "<leader>fe", "<Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>")
  vim.keymap.set("n", "<leader>ff", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")
  vim.keymap.set("n", "<leader>sr", "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>")
  vim.keymap.set("n", "<C-w>v", "<Cmd>call VSCodeNotify('workbench.action.splitEditor')<CR>")
  vim.keymap.set("n", "<C-w>s", "<Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>")
end
