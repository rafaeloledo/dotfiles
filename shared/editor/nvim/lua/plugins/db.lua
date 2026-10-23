return {
  {
    "tpope/vim-dadbod",
    cmd = { "DB", "DBUI" },
    lazy = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
      "DBUIRenameBuffer",
      "DBUILastQueryInfo",
    },
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<CR>", desc = "Toggle Dadbod UI" },
      { "<leader>du", "<cmd>DBUIToggle<CR>", desc = "Toggle Dadbod UI" },
      { "<leader>df", "<cmd>DBUIFindBuffer<CR>", desc = "Dadbod Find Buffer" },
      { "<leader>dr", "<cmd>DBUIRenameBuffer<CR>", desc = "Dadbod Rename Buffer" },
      { "<leader>dl", "<cmd>DBUILastQueryInfo<CR>", desc = "Dadbod Last Query Info" },
    },
    init = function()
      local data_path = vim.fn.stdpath("data")

      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 35
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = data_path .. "/db_ui"

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          vim.bo.omnifunc = "vim_dadbod_completion#omni"
        end,
      })
    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    dependencies = { "tpope/vim-dadbod" },
    lazy = true,
  },
}
