return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = { enabled = false },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = false },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = false },
		words = { enabled = true },
	},
	keys = {
		{
			"<c-/>",
			function()
				Snacks.terminal.toggle()
			end,
			desc = "Toggle Terminal",
		},
	},
	config = function()
		vim.api.nvim_create_autocmd("TermOpen", {
			callback = function()
				vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = true, noremap = true, silent = true })
				vim.keymap.set("t", "<C-/>", function ()
				  Snacks.terminal.toggle()
				end, { buffer = true, noremap = true, silent = true })
			end,
		})
	end,
}
