return {
  "stevearc/oil.nvim",
  opts = {
    columns = {
      -- "mtime",
      -- "permissions",
      -- "size",
      "icon",
    },
    view_options = {
      sort = {
        -- { "mtime", "desc" }
      },
    },
    preview_win = {
      preview_method = "load",
      win_options = {
        wrap = true
      },
    },
  }
}
