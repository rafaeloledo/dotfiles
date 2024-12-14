local group = vim.api.nvim_create_augroup("user-persistence", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "PersistenceSavePre",
  callback = function()
    vim.cmd(":Neotree close")
  end,
})

-- Lua
return {
  "folke/persistence.nvim",
  event = "VimEnter",
  opts = {
    need = 0,
    branch = false,
  },
}
