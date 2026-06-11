return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("vscode")
    end,
  },
  { "folke/tokyonight.nvim", lazy = true },
}
