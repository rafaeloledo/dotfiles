vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Remove trailing whitespace on save',
  group = vim.api.nvim_create_augroup('remove_trailing_whitespace', { clear = true }),
  callback = function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    -- %s          - Apply to all lines in the buffer (% is the range specifier for the entire file)
    -- \s\+        - Match one or more whitespace characters
    -- $           - Match at the end of line
    -- e           - Suppress errors if pattern is not found
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end,
})

if vim.fn.argc() == 1 then
  vim.api.nvim_create_user_command('PatchDir', function()
    vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
  end, { desc = 'Patch Dir' })
end

vim.api.nvim_create_autocmd('BufRead', {
  pattern = {'*.*'},
  callback = function(data)
    require('local-highlight').attach(data.buf)
  end
})
