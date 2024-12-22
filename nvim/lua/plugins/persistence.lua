return {
  "folke/persistence.nvim",
  event = "VimEnter",
  keys = {
    {
      "<C-s>",
      function()
        require("persistence").load({ last = true })
      end,
      desc = "Restore Last Session",
    },
  },
  opts = {
    need = 0,
    branch = false,
  },
}
