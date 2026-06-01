local M = {}

function M.toggleInlayHints()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

function M.toggleAutoformat()
  vim.g.autoformat = not vim.g.autoformat
end

return M
