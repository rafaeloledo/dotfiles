local nixos = require("config.nixos")

return {
  nixos,

  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
  },

  { "mistricky/codesnap.nvim", build = "make" },
  { "Mofiqul/vscode.nvim" },
}
