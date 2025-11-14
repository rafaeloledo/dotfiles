return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{
				"nvim-tree/nvim-web-devicons",
				enabled = vim.g.have_nerd_font,
			},
		},
		config = function()
			require("telescope").setup({
				extensions = {
					wrap_results = true,
					fzf = {},
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")

			local ignore_patterns = {
				".git",
				"node_modules",
				"__pycache__",
				".venv",
				".tox",
				".idea",
				".DS_Store",
				".png",
				"%lock.json",
				"%.lock",
				".jpg",
				".jpeg",
				".svg",
				".gif",
				".ttf",
			}

			vim.keymap.set("n", ";f", function()
				builtin.find_files({
					file_ignore_patterns = ignore_patterns,
				})
			end)

			vim.keymap.set("n", "<leader><space>", function()
				builtin.find_files({
					file_ignore_patterns = ignore_patterns,
				})
			end)

			vim.keymap.set("n", ";r", builtin.live_grep)
			vim.keymap.set("n", "<leader>r", builtin.live_grep)
			vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)
			vim.keymap.set("n", "<space>sw", builtin.grep_string)
			vim.keymap.set("n", ";;", builtin.resume)
		end,
	},

}
