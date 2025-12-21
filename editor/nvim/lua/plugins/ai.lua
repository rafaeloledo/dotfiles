return {
	{
		"rhart92/codex.nvim",
		opts = {
			split = "float",
			float = {
				width = 0.8,
				height = 0.8,
				border = "rounded",
				title = "Codex",
			},
		},
		keys = {
			{
				"<leader>cc",
				function()
					require("codex").toggle()
				end,
				desc = "Codex: Toggle",
			},
			{
				"<leader>cs",
				function()
					require("codex").actions.send_selection()
				end,
				mode = "v",
				desc = "Codex: Send selection",
			},
		},
	},
}
