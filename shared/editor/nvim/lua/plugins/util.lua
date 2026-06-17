local op = "/home/rgnh55/sync/notes"
-- local op = "C:\\sync\\anotacoes"

return {
	{ "xiyaowong/transparent.nvim", enabled = false },
	{ "nvim-lua/plenary.nvim" },
	-- { "mistricky/codesnap.nvim", build = "make build_generator" },
	{ "mbbill/undotree", enabled = false },

	{
		"nvim-flutter/flutter-tools.nvim",
    enabled = false,
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
