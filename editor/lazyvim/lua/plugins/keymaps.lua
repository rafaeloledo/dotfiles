local persistence = require("persistence")
local minifiles = require("mini.files")

-- Paste directlu with C-v in insert mode
-- For me, there's no reason to user C-S-v instead
vim.keymap.set("i", "<C-V>", "<C-r>+")

-- Split window
vim.keymap.set("n", "ss", ":split<Return>")
vim.keymap.set("n", "sv", ":vsplit<Return>")

-- Move window
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sl", "<C-w>l")

-- Resize window
vim.keymap.set("n", "<C-w><left>", "<C-w><")
vim.keymap.set("n", "<C-w><right>", "<C-w>>")
vim.keymap.set("n", "<C-w><up>", "<C-w>+")
vim.keymap.set("n", "<C-w><down>", "<C-w>-")

vim.keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end)

-- Ctrl-z is a useful keymap
-- But it's in a non ergonomic key
vim.keymap.set("n", "<C-q>", "<C-z>")
vim.keymap.set("n", "<C-z>", "<nop>")

-- Mitchell Hashimoto
vim.keymap.set("n", "<C-t>", ":tabedit<CR>")
vim.keymap.set("n", "<C-c>", ":tabclose<CR>")

-- craftzdog (Takuya Matsuyama)
vim.keymap.set({ "n", "v", "x" }, "+", "<C-a>")
vim.keymap.set({ "n", "v", "x" }, "-", "<C-x>")

vim.keymap.set("n", "<leader>r", function()
  require("craftzdog.hsl").replaceHexWithHSL()
end)

vim.keymap.set("n", "<leader>i", function()
  require("craftzdog.lsp").toggleInlayHints()
end)

vim.api.nvim_create_user_command("ToggleAutoformat", function()
  require("craftzdog.lsp").toggleAutoformat()
end, {})

local file_ignore_patterns = {
  ".git/",
  "%.o",
  "%.so",
  "%.a",
  "%.out",
  "%.class",
  "%.pdf",
  "%.mkv",
  "%.mp4",
  "%.zip",
  "%.png",
  "%.jpg",
  "%.jpeg",
  "%.svg",
  "%.webp",
}

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = {
      {
        ";f",
        function()
          local builtin = require("telescope.builtin")
          builtin.find_files({
            no_ignore = false,
            hidden = true,
            file_ignore_patterns = file_ignore_patterns,
          })
        end,
        desc = "Find Files",
      },
      {
        ";r",
        function()
          local builtin = require("telescope.builtin")
          builtin.live_grep({
            additional_args = { "--hidden" },
          })
        end,
        desc = "Live Grep",
      },
      {
        ";;",
        function()
          local builtin = require("telescope.builtin")
          builtin.resume()
        end,
        desc = "Resume",
      },
      {
        ";e",
        function()
          local builtin = require("telescope.builtin")
          builtin.diagnostics()
        end,
        desc = "Lists Diagnostics for all open buffers or a specific buffer",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          n = {},
        },
      })
      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
      }
      telescope.setup(opts)
      require("telescope").load_extension("fzf")
    end,
  },

  {
    "echasnovski/mini.files",
    keys = {
      {
        "sf",
        function()
          minifiles.open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Mini Files",
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      -- prefer H and L for start and end of line
      -- so use tabs
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
      -- i often missclick these
      -- i also prefer it
      -- jumping around start and end of lines
      { "H", "^" },
      { "L", "$" },
      -- it drives me nuts
      { "<Esc>", "<nop>" },
    },
  },

  -- helps back faster to last or specified session with neovide
  {
    "folke/persistence.nvim",
    keys = {
      -- my entries
      {
        ";s",
        function()
          persistence.select()
        end,
        desc = "Select a Session",
      },
      {
        ",s",
        function()
          persistence.load({ last = true })
        end,
        desc = "Load Last Session",
      },
    },
  },
}
