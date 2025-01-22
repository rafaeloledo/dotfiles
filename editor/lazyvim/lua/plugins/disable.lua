return {
  -- the reason i'm doing this is that i want to leverate from
  -- sensible LazyVim default configs and LazyVim Extras sections
  -- specially for LSPs like Java
  --
  --
  -- but i don't want mappigns that i don't use
  -- so i may have freedom to map them for somethind else on dont
  -- use triple keychord bindings that i find slow to type

  -- do not conflict with mini
  {
    "folke/flash.nvim",
    enabled = false,
  },

  -- batch negate
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
    },
    keys = {
      -- buffers
      { "<leader>,", false },
      -- duplicated live grep
      { "<leader>/", false },
      -- command history
      { "<leader>:", false },
      -- duplicated find files
      { "<leader><space>", false },

      -- find files
      { "<leader>ff", false },
      -- find files ...
      { "<leader>fF", false },
      -- find buffers
      { "<leader>fb", false },
      -- find buffers ...
      { "<leader>fB", false },
      -- find config files
      { "<leader>fc", false },
      -- find recent
      { "<leader>fr", false },
      -- find recent ...
      { "<leader>fR", false },
      -- find project
      { "<leader>fp", false },

      -- file explorer
      { "<leader>fe", false },
      -- file explorer ...
      { "<leader>fE", false },
    },
  },

  -- batch negate
  {
    "echasnovski/mini.files",
    keys = {
      { "<leader>fM", false },
      { "<leader>fm", false },
    },
  },

  -- batch negate
  {
    "folke/persistence.nvim",
    keys = {
      { "<leader>ql", false },
      { "<leader>qd", false },
      { "<leader>qs", false },
      { "<leader>qS", false },
    },
  },
}
