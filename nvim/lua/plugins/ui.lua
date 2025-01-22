return {
  {
		"snacks.nvim",
		opts = {
			scroll = { enabled = false },
		},
		keys = {},
	},

  {
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
	},

  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
    }
  }
}
