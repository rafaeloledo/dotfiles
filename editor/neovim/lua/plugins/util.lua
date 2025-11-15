local op = "/home/rgnh55/sync/notes"
-- local op = "C:\\sync\\anotacoes"

return {
	{ "xiyaowong/transparent.nvim" },
	{ "nvim-lua/plenary.nvim" },
	{ "mistricky/codesnap.nvim", build = "make build_generator" },
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
    enabled = false,
		version = "*",
		ft = "markdown",
		opts = {
			workspaces = {
				{
					name = "personal",
					path = op,
				},
			},
		},
		keys = { { "<leader>p", "<cmd>ObsidianPasteImg<CR>" } },
	},
}
