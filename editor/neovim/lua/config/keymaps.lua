local keymap = vim.keymap

keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<CR>")

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
keymap.set("i", "<C-v>", "<C-r>+", { desc = "Paste from clipboard" })

keymap.set({ "n", "v", "x" }, "+", "<C-a>", { desc = "Increment" })
keymap.set({ "n", "v", "x" }, "-", "<C-x>", { desc = "Decrement" })

keymap.set("t", "<M-q>", "<C-\\><C-n>", { noremap = true, silent = true })

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

keymap.set("n", "dw", 'vb"_d')
keymap.set("n", "=ap", "ma=ap'a")

if vim.g.vscode then
	keymap.set("n", "<leader><space>", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")
	keymap.set("n", "<leader>sr", "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>")
	keymap.set("n", "<C-w>v", "<Cmd>call VSCodeNotify('workbench.action.splitEditor')<CR>")
	keymap.set("n", "<C-w>s", "<Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>")
	keymap.set("n", "<S-h>", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
	keymap.set("n", "<S-l>", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")
else
	keymap.set("n", "<S-l>", "<cmd>bn<CR>", { desc = "Tab Next" })
	keymap.set("n", "<S-h>", "<cmd>bp<CR>", { desc = "Tab Previous" })
  keymap.set("n", "<C-c>", "<cmd>bd<CR>", { desc = "Close current buffer"})

	keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
	keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
	keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window Up" })
	keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window Right" })

	keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undo Tree" })

  keymap.set("n", "<C-p>", function ()
    require('mini.files').open()
  end)

	keymap.set("n", "<C-t>", "<cmd>tabedit<CR>")
	keymap.set("n", "<leader>bd", "<cmd>bd<CR>")

	keymap.set("n", "<leader>qs", function()
		require("persistence").load()
	end, { desc = "Load session from current dir" })

	keymap.set("n", "<leader>qS", function()
		require("persistence").select()
	end, { desc = "Select session to load" })

	keymap.set("n", "<leader>ql", function()
		require("persistence").load({ last = true })
	end, { desc = "Load last session" })

	keymap.set("n", "<leader>fn", function()
		OpenNautilus()
	end, { desc = "Open Nautilus" })

	keymap.set("n", "<leader>fe", "<cmd>Neotree toggle<CR>", { desc = "Open Neo-Tree" })

	keymap.set("n", "<leader>r", function()
		require("craftzdog.hsl").replaceHexWithHSL()
	end)

	keymap.set("n", "<leader>i", function()
		require("craftzdog.lsp").toggleInlayHints()
	end)

	vim.api.nvim_create_user_command("ToggleAutoformat", function()
		require("craftzdog.lsp").toggleAutoformat()
	end, {})

	function OpenNautilus(path)
		local target = path or vim.fn.getcwd()
		vim.fn.jobstart({ "nautilus", target }, {
			detach = true,
			on_exit = function() end,
		})
	end

	keymap.set("n", "<leader>f", function()
		require("conform").format()
	end)
end
