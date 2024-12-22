return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = false,
  opts = {
    hijack_netrw_behavior = "open_default",
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
}
