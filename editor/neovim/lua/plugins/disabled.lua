local harpoon = {
	"ThePrimeagen/harpoon",
  enabled = false,
	branch = "harpoon2",
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		vim.keymap.set("n", "<M-a>", function()
			harpoon:list():add()
		end)

		vim.keymap.set({"n", "i"}, "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		vim.keymap.set({"n", "i"}, "<C-h>", function()
			harpoon:list():select(1)
		end)

		vim.keymap.set({"n", "i"}, "<C-j>", function()
			harpoon:list():select(2)
		end)

		vim.keymap.set({"n", "i"}, "<C-k>", function()
			harpoon:list():select(3)
		end)

		vim.keymap.set({"n", "i"}, "<C-l>", function()
			harpoon:list():select(4)
		end)
	end,
}

return harpoon
