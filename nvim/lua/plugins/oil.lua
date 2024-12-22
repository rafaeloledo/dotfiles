if vim.fn.exists(":Oil") > 0 then
  vim.keymap.set("n", "-", "<cmd>Oil<CR>")
end

return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
      skip_confirm_for_simple_edits = true,
      is_always_hidden = function(name, _)
        return name == ".." or name == ".git"
      end,
    },
    preview_win = {
      preview_method = "load",
    },
  },
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
