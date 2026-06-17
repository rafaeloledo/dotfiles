local ignore_patterns = {
  ".git", "node_modules", "__pycache__", ".venv", ".tox", ".idea",
  ".DS_Store", ".png", "%lock.json", "%.lock", ".jpg", ".jpeg",
  ".svg", ".gif", ".ttf",
}

local function find_files()
  require("telescope.builtin").find_files({ file_ignore_patterns = ignore_patterns })
end

return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    cmd = "Telescope",
    keys = {
      { ";f", find_files },
      { "<leader><space>", find_files },
      { ";r", function() require("telescope.builtin").live_grep() end },
      { "<leader>r", function() require("telescope.builtin").live_grep() end },
      { "<leader>/", function() require("telescope.builtin").current_buffer_fuzzy_find() end },
      { "<space>sw", function() require("telescope.builtin").grep_string() end },
      { ";;", function() require("telescope.builtin").resume() end },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      require("telescope").setup({
        defaults = { wrap_results = true },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })
      pcall(require("telescope").load_extension, "ui-select")
    end,
  },
}
