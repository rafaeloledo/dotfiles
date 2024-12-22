require('bufferline').setup{
	options = {
		-- open buffer in the current tab
		mode = "tabs",
		always_show_bufferline = false,
	},
}

-- Don't use Tabs here, conflicts with <C-i>
vim.keymap.set("n", "tn", ":BufferLineCycleNext<CR>", { silent = true })
vim.keymap.set("n", "tp", ":BufferLineCyclePrev<CR>", { silent = true })
