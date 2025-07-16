-- local op = "/home/rgnh55/sync/anotacoes"
local op = "C:\\sync\\anotacoes"

return {
	{ "xiyaowong/transparent.nvim" },
	{ "nvim-lua/plenary.nvim" },
	-- { "mistricky/codesnap.nvim", build = "make" },
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
