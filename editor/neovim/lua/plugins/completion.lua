local sources = {
	default = { "lsp", "path", "snippets", "buffer", "copilot" },
  per_filetype = { sql = { 'dadbod' } },
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
			keymap = { preset = "default" },
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = { documentation = { auto_show = false } },
			sources = sources,
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
