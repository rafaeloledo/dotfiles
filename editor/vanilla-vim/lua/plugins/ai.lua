return {
  -- Copilot Lua implementation (better than the official plugin for integration)
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
  },

  -- Copilot cmp source - integrates with nvim-cmp
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("copilot_cmp").setup({
      })
    end,
  },

  -- Copilot Chat (similar to VSCode's Copilot Chat)
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "CopilotChat",
      "CopilotChatExplain",
      "CopilotChatTests",
      "CopilotChatReview",
      "CopilotChatFix",
    },
    opts = {},
  },
}
