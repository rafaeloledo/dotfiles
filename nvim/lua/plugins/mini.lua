return {
  {
    "echasnovski/mini.files",
    event = "BufEnter",
    opts = {
      windows = {
        width_preview = 85,
      },
      options = {
        use_as_default_explorer = true,
      },
      mappings = {
        close = "<Esc>",
        reset = "q",
        go_in_plus = "l",
      },
    },
  },

  -- disable animations
  {
    "echasnovski/mini.animate",
    enabled = false,
  },
  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
  },
}
