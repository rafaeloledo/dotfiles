return {
  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      -- Mitchell Hashimoto
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
      -- i often missclick these
      -- i also prefer it
      -- jumping around start and end of lines
      { "H", "^" },
      { "L", "$" },
      -- it drives me nuts
      { "<Esc>", "<nop>" }
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

  --- statusline
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

  {
    "mistricky/codesnap.nvim",
    build = "make"
  }
}
