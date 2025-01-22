return {
  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
    keys = {},
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "emmet-language-server",
      },
    },
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          modified_sign = "",
          readonly_icon = " 󰌾 ",
        }),
      }
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
██████╗  █████╗ ███████╗ █████╗ ███████╗██╗      ██████╗ ██╗     ███████╗██████╗  ██████╗ 
██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔════╝██║     ██╔═══██╗██║     ██╔════╝██╔══██╗██╔═══██╗
██████╔╝███████║█████╗  ███████║█████╗  ██║     ██║   ██║██║     █████╗  ██║  ██║██║   ██║
██╔══██╗██╔══██║██╔══╝  ██╔══██║██╔══╝  ██║     ██║   ██║██║     ██╔══╝  ██║  ██║██║   ██║
██║  ██║██║  ██║██║     ██║  ██║███████╗███████╗╚██████╔╝███████╗███████╗██████╔╝╚██████╔╝
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚══════╝╚══════╝╚═════╝  ╚═════╝ 
          ]],
        },
      },
    },
  },
}
