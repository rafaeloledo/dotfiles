return {
	{ "echasnovski/mini.statusline", opts = {} },
	{ "echasnovski/mini.tabline", opts = {} },
	-- { "echasnovski/mini.cursorword", opts = {} },
	{ "echasnovski/mini.indentscope", opts = {} },
	{ "echasnovski/mini.diff", opts = {} },
	{ "echasnovski/mini.move", opts = {} },
	{ "echasnovski/mini.extra", opts = {} },
	-- { "echasnovski/mini.surround", opts = {} },
	{ "echasnovski/mini.ai", opts = {} },
	{ "echasnovski/mini.pairs", opts = {} },
	{ "echasnovski/mini.icons", opts = {} },
	{ "echasnovski/mini.comment", opts = {} },
	{ "echasnovski/mini.align", opts = {} },
	{ "echasnovski/mini.jump", opts = {} },
	{ "echasnovski/mini.misc", opts = {} },

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

	{
		"echasnovski/mini.files",
    enabled = false,
		keys = {
			{
				"<C-p>",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
				end,
				desc = "Open mini.files (Directory of Current File)",
			},
		},
	},

	{
		"echasnovski/mini.pick",
    enabled = false,
		opts = {},
		keys = {
			{ ";f", "<cmd>Pick files<CR>" },
			{ ";r", "<cmd>Pick grep_live<CR>" },
			{ ";;", "<cmd>Pick resume<CR>" },
		},
	},
}
