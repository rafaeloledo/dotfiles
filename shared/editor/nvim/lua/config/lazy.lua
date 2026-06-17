local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "man",          -- irrelevant on Windows
        "matchit",
        "netrw",
        "netrwPlugin",  -- you use oil.nvim
        "tarPlugin",
        "tutor",
        "zipPlugin",
        "spellfile",
        "editorconfig", -- only if you don't use .editorconfig files
        "rplugin",      -- only if you have no remote (Python/Ruby) plugins
      },
    },
  },
  checker = { enabled = false },
  change_detection = { enabled = false },
})
