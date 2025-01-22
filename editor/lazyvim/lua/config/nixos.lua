local M = {}

if os.getenv("NIXOS_OZONE_WL") == "1" then
  M = {
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

return M
