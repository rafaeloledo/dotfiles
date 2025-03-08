return {
	{ "xiyaowong/transparent.nvim" },
	{ "nvim-lua/plenary.nvim" },
	{ "mistricky/codesnap.nvim", build = "make" },
	{ "mbbill/undotree" },

	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = { "stevearc/dressing.nvim" },
		config = true,
		opts = {},
	},

	{
		"epwalsh/obsidian.nvim",
		version = "*",
		ft = "markdown",
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "/home/rgnh55/sync/anotacoes",
				},
			},
		},
		keys = { { "<leader>p", "<cmd>ObsidianPasteImg<CR>" } },
	},
}
