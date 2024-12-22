return {
  {
    "Mofiqul/vscode.nvim",
    config = function()
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
    config = function()
      vim.cmd('colorscheme solarized-osaka')
    end,
  },
  {
    "rose-pine/neovim",
    as = "rose-pine"
  }
}
