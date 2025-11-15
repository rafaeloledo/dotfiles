local function open_vscode_here()
  vim.api.nvim_command("silent !code .")
end

vim.api.nvim_create_user_command(
  'Vscode',
  open_vscode_here,
  {}
)

local function open_cursor_here()
  vim.api.nvim_command("silent !cursor .")
end

vim.api.nvim_create_user_command(
  'Cursor',
  open_cursor_here,
  {}
)

local function open_windsurf_here()
  vim.api.nvim_command("silent !windsurf .")
end

vim.api.nvim_create_user_command(
  "Windsurf",
  open_windsurf_here,
  {}
)
