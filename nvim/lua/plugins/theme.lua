return {
  {
    "Mofiqul/vscode.nvim",
    config = function()
      require("vscode").setup()
      vim.cmd("colorscheme vscode")
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    config = true,
    opts = ...,
  },
}
