return {
  {
    "folke/flash.nvim",
    enabled = false,
    ---@type Flash.Config
    opts = {
      search = {
        forward = true,
        multi_window = false,
        wrap = false,
        incremental = true,
      },
    },
  },

  {
    "ibhagwan/fzf-lua",
    keys = {
      {
        ";f",
        LazyVim.pick("files"),
        desc = "Find Files",
      },
      {
        ";r",
        LazyVim.pick("live_grep"),
        desc = "Live Grep",
      },
      {
        ";e",
        "<cmd>FzfLua diagnostics_workspace<cr>",
        desc = "Lists Diagnostics for all open buffers or a specific buffer",
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    opts = {
      hijack_netrw_behavior = "open_default",
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },
}