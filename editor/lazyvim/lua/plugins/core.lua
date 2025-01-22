vim.g.lazyvim_picker = "telescope"

-- default for no nixos
local nixos = {}

-- this means i'm on NixOS (using Wayland btw)
if os.getenv("NIXOS_OZONE_WL") == "1" then
  -- handle all lsp and formatters in nixos flake
  -- if in other distro, just use LazyVim default configs
  nixos = {
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          lua_ls = {
            mason = false,
          },
        },
      },
    },

    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {},
      },
      config = function(_, opts)
        require("mason").setup(opts)
      end,
    },

    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {},
        automatic_installation = false,
      },
      config = function(_, opts)
        require("mason-lspconfig").setup(opts)
      end,
    },
  }
end

return {
  nixos,

  {
    "snacks.nvim",
    opts = {
      -- i want no animation, just go fater with acceleration
      scroll = { enabled = false },
    },
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },

  --- statusline (takuya matsuyama)
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = "cwd",
          modified_hl = "MatchParen",
          filename_hl = "Bold",
          modified_sign = " [+]",
          readonly_icon = " 󰌾 ",
        }),
      }
    end,
  },

  -- cool code prints
  { "mistricky/codesnap.nvim", build = "make" },

  -- better theme in lighter environments
  { "Mofiqul/vscode.nvim" },

  { "craftzdog/solarized-osaka.nvim" },

  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          winblend = vim.o.pumblend,
        },
      },
      signature = {
        window = {
          winblend = vim.o.pumblend,
        },
      },
    },
  },
}
