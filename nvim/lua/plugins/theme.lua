return {
  {
    "Mofiqul/vscode.nvim",
    config = function()
      vim.cmd('colorscheme vscode')
      require("vscode").setup()
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    config = true,
    opts = ...,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    opts = {},
  },
  {
    "rose-pine/neovim",
    as = "rose-pine"
  }
}
