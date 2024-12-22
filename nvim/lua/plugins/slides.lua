if vim.fn.exists(":Slides") > 0 then
  vim.keymap.set("n", "<leader>ts", ":Slides<CR>")
end

return {
  "aspeddro/slides.nvim",
  config = function()
    require("slides").setup()
  end,
}
