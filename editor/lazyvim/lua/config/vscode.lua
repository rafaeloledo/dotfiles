local M = {}

M.is_vscode = function()
  return vim.g.vscode == 1
end

return M 