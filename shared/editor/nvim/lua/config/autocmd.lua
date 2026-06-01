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

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  desc = 'Reload buffer when file changes on disk',
  group = vim.api.nvim_create_augroup('auto_reload_changed_files', { clear = true }),
  callback = function()
    if vim.fn.mode() ~= 'c' and vim.fn.bufexists(0) == 1 then
      vim.cmd('checktime')
    end
  end,
})

vim.api.nvim_create_autocmd('FileChangedShellPost', {
  desc = 'Notify when buffer is reloaded due to external change',
  group = vim.api.nvim_create_augroup('notify_file_changed', { clear = true }),
  callback = function()
    vim.notify('File changed on disk. Buffer reloaded.', vim.log.levels.WARN)
  end,
})

if vim.fn.argc() == 1 then
  vim.api.nvim_create_user_command('PatchDir', function()
    vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
  end, { desc = 'Patch Dir' })
end

-- vim.api.nvim_create_autocmd('BufRead', {
--   pattern = {'*.*'},
--   callback = function(data)
--     require('local-highlight').attach(data.buf)
--   end
-- })
