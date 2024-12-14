require('telescope').load_extension('git_worktree')

local telescope = require('telescope')
local actions = require("telescope.actions")
local fb_actions = require("telescope").extensions.file_browser.actions

telescope.setup {
	defaults = {
		layout_strategy = "horizontal",
		layout_config = {
			prompt_position = "top",
		},
		wrap_results = true,
		sorting_strategy = "ascending",
		winblend = 0,
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
				["<C-j>"] = require('telescope.actions').move_selection_next,
				["<C-k>"] = require('telescope.actions').move_selection_previous,
				["<C-d>"] = require('telescope.actions').move_selection_previous,
			},
			n = {
				['<C-f>'] = require('telescope.actions').preview_scrolling_left,
				['<C-k>'] = require('telescope.actions').preview_scrolling_right,
			}
		},
	},
	pickers = {
		diagnostics = {
			theme = "ivy",
			initial_mode = "normal",
			layout_config = {
				preview_cutoff = 9999,
			},
		},
	},
	extensions = {
		file_browser = {
			theme = "dropdown",
			hijack_netrw = true,
			mappings = {
				-- your custom insert mode mappings
				["n"] = {
					-- your custom normal mode mappings
					["N"] = fb_actions.create,
					["h"] = fb_actions.goto_parent_dir,
					["/"] = function()
						vim.cmd("startinsert")
					end,
					["<C-u>"] = function(prompt_bufnr)
						for i = 1, 10 do
							actions.move_selection_previous(prompt_bufnr)
						end
					end,
					["<C-d>"] = function(prompt_bufnr)
						for i = 1, 10 do
							actions.move_selection_next(prompt_bufnr)
						end
					end,
					["<PageUp>"] = actions.preview_scrolling_up,
					["<PageDown>"] = actions.preview_scrolling_down,
				},
			},
		},
	},
}

local set = vim.keymap.set
local builtin = require('telescope.builtin')

set('n', '<C-p>', builtin.find_files)
set('n', ';d', builtin.diagnostics)
set('n', ';r', builtin.live_grep)

set('n', '<leader>sb', builtin.buffers)
set('n', '<leader>sw', builtin.grep_string)
set('n', '<leader>gs', builtin.git_status)

require("telescope").load_extension "file_browser"

vim.keymap.set("n", "sf", function()
	local telescope = require("telescope")

	local function telescope_buffer_dir()
		return vim.fn.expand("%:p:h")
	end

	telescope.extensions.file_browser.file_browser({
		path = "%:p:h",
		cwd = telescope_buffer_dir(),
		respect_gitignore = false,
		hidden = true,
		grouped = true,
		previwer = false,
		initial_mode = "normal",
		layout_config = { height = 40 }
	})
end)
