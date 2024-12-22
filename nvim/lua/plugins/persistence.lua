if vim.fn.exists(":Neotree") > 0 then
  local group = vim.api.nvim_create_augroup("user-persistence", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "PersistenceSavePre",
    callback = function()
      vim.cmd(":Neotree close")
    end,
  })
end

-- Lua
return {
  "folke/persistence.nvim",
  event = "VimEnter",
  opts = {
    need = 0,
    branch = false,
  },
}
