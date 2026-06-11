return {
  { "echasnovski/mini.indentscope", enabled = false, opts = {} },
  { "echasnovski/mini.diff",  event = "VeryLazy", opts = {} },
  { "echasnovski/mini.move",  event = "VeryLazy", opts = {} },
  { "echasnovski/mini.extra", lazy = true, opts = {} },
  { "echasnovski/mini.ai",    event = "VeryLazy", opts = {} },
  { "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },
  { "echasnovski/mini.icons", lazy = true, opts = {} },
  { "echasnovski/mini.align", event = "VeryLazy", opts = {} },
  { "echasnovski/mini.misc",  lazy = true, opts = {} },

  -- alternative for lualine
  {
    "echasnovski/mini.statusline",
    -- enabled = false,
    opts = {},
    config = function()
      require('mini.statusline').setup({
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 1000 })

            -- Custom fugitive function (guarded so statusline doesn't autoload fugitive)
            local fugitive = function()
              if vim.fn.exists('*FugitiveHead') ~= 1 then return '' end
              local head = vim.fn.FugitiveHead()
              if head and head ~= '' then
                return ' ' .. head
              else
                return ''
              end
            end

            local git           = MiniStatusline.section_git({ trunc_width = 40 })
            local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
            local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location      = MiniStatusline.section_location({ trunc_width = 75 })
            local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

            return MiniStatusline.combine_groups({
              { hl = mode_hl,                  strings = { mode } },
              { hl = 'MiniStatuslineDevinfo',  strings = { fugitive(), git, diff, diagnostics, lsp } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl,                  strings = { search, location } },
            })

          end,
        },
      })
    end
  },

  -- `gcc` to toggle line comment
  { "echasnovski/mini.comment", event = "VeryLazy", opts = {} },

  -- with this you can type `fe` and then press `f` to jump to next ocurrencies
  { "echasnovski/mini.jump", event = "VeryLazy", opts = {} },

  -- just hipatterns (replaces the full mini.nvim monolith)
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPost",
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },
}
