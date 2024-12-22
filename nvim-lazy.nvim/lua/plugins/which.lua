local wk = require("which-key")

wk.add({

	{ "<leader>bb", group = "buffers", expand = function()
      return require("which-key.extras").expand.buf()
    end
  },
	{ "<leader>b", group = "Buffer" },
	{ "<leader>bo", ":ls<cr>:b<space>", desc = "Open", mode = "n" },
	{ "<leader>bd", ":bd<cr>", desc = "Delete" },
	{ "<leader>bl", ":bnext<cr>", desc = "Next" },
	{ "<leader>bk", ":blast<enter>", desc = "Last" },
	{ "<leader>bj", ":bfirst<enter>", desc = "First" },
	{ "<leader>bh", ":bprev<enter>", desc = "Prev" },

	{ "<leader>w", proxy = "<c-w>", group = "windows" },
	{ "<leader>q", ":q<cr>", group = "windows" },
	{ '<leader>mm', ':messages<cr>', desc = "Show messages" },
	{
		"<leader>ot",
		":silent !C:\\dev\\scoop\\apps\\wezterm\\current\\wezterm-gui.exe start --cwd .<CR>",
		desc = "External Terminal"
	},

	{ "<leader>g", group = "Git" },
	{ "<leader>gg", ":LazyGit<cr>", desc = "Lazy" }

})
