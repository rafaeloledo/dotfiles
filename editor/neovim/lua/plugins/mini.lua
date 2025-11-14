return {
	{ "echasnovski/mini.indentscope", opts = {} },
	{ "echasnovski/mini.diff", opts = {} },
	{ "echasnovski/mini.move", opts = {} },
	{ "echasnovski/mini.extra", opts = {} },
	{ "echasnovski/mini.ai", opts = {} },
	{ "echasnovski/mini.pairs", opts = {} },
	{ "echasnovski/mini.icons", opts = {} },
	{ "echasnovski/mini.align", opts = {} },
	{ "echasnovski/mini.misc", opts = {} },

  -- alternative for lualine
	{ "echasnovski/mini.statusline", opts = {} },

  -- `gcc` to toggle line comment
	{ "echasnovski/mini.comment", opts = {} },

  -- with this you can type `fe` and then press `f` to jump to next ocurrencies
	{ "echasnovski/mini.jump", opts = {} },

	{
		"echasnovski/mini.nvim",
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
