if not vim.g.vscode then

return {
	{
		"zbirenbaum/copilot.lua",
    enabled = false,
		dependencies = {},
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = {
				auto_trigger = false,
				keymap = {
					accept = "<M-]>",
					accept_word = false,
					accept_line = false,
					next = false,
					prev = false,
					dismiss = "<C-]>",
				},
			},
			copilot_model = "gpt-4o-copilot",
		},
	},

	{
		"yetone/avante.nvim",
    enabled = false,
		event = "VeryLazy",
		version = false,
		opts = {
			provider = "copilot",
			openai = {
				endpoint = "https://api.openai.com/v1",
				timeout = 30000,
				temperature = 0,
				max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
				--reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
			},
		},
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						use_absolute_path = false,
					},
				},
			},
			{
				"MeanderingProgrammer/render-markdown.nvim",
        enabled = false,
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},

}
else
  return {}
end
