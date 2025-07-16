if not vim.g.vscode then
	local sources = {
		default = { "lsp", "path", "snippets", "buffer", "copilot" },
    per_filetype = { sql = { "dadbod" } },
		providers = {
			dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			copilot = {
				name = "copilot",
				module = "blink-copilot",
				score_offset = 100,
				async = true,
				opts = {
					max_completions = 3,
				},
			},
		},
	}

  return {
    {
      "saghen/blink.cmp",
      dependencies = {
        "rafamadriz/friendly-snippets",
        { "fang2hou/blink-copilot", opts = {} },
      },
      version = "1.*",
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        keymap = {
          preset = "default",
          ["<CR>"] = { "accept", 'fallback' },
        },
        appearance = {
          nerd_font_variant = "mono",
        },
        completion = {
          documentation = { auto_show = true },
          list = {
            selection = {
              preselect = true,
              -- auto_select = false,
            }
          },
        },
        cmdline = {
          keymap = {
            ["<Tab>"] = { "show", "accept" },
          },
          completion = {
            menu = {
              auto_show = function(ctx)
                return vim.fn.getcmdtype() == ":"
              end,
            },
          },
        },
        sources = sources,
        fuzzy = { implementation = "prefer_rust_with_warning" },
      },
      opts_extend = { "sources.default" },
    },
  }
else
  return {}
end
