local op = ""

if vim.fn.has("win32") == 1 or vim.fn.has("win64") then
  op = "D:\\sync\\anotacoes"
else
  op = "/home/rgnh55/sync/anotacoes"
end

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
