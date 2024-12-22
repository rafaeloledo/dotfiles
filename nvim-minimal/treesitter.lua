add_to_pkgpath("plugins/nvim-treesitter/lua/?.lua")
add_to_pkgpath("plugins/nvim-treesitter/lua/nvim-tresitter/?.lua")

local treesitter = require("treesitter")
local configs = require("nvim-treesitter.configs")

treesitter.setup()

configs.setup({
	ensure_installed = {
		"c",
	},
	modules = {
		highlight = { enable = true },
	}
})
