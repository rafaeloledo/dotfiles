local ignore_patterns = {
  ".git", "node_modules", "__pycache__", ".venv", ".tox", ".idea",
  ".DS_Store", ".png", "%lock.json", "%.lock", ".jpg", ".jpeg",
  ".svg", ".gif", ".ttf",
}

local function find_files()
  require("telescope.builtin").find_files({ file_ignore_patterns = ignore_patterns })
end

-- Telescope's builtin resume replays the cached result list. Re-run the last
-- picker instead, keeping the query that was in the prompt.
local last_picker
local pending_gen = 0

local function clone_opts(opts)
  if type(opts) ~= "table" then
    return nil
  end
  local ok, copy = pcall(vim.deepcopy, opts)
  if ok then
    return copy
  end
  return vim.tbl_extend("force", {}, opts)
end

local function install_resume_redo()
  local builtin = require("telescope.builtin")
  local pickers = require("telescope.pickers")
  if pickers._resume_redo then
    return
  end
  pickers._resume_redo = true

  local Picker = pickers._Picker
  local orig_find = Picker.find
  function Picker:find(...)
    if pending_gen ~= 0 then
      self._resume_gen = pending_gen
      pending_gen = 0
    end
    return orig_find(self, ...)
  end

  local orig_close = pickers.on_close_prompt
  function pickers.on_close_prompt(prompt_bufnr)
    local status = require("telescope.state").get_status(prompt_bufnr)
    local picker = status and status.picker
    if picker and last_picker and picker._resume_gen == last_picker.gen then
      local ok, prompt = pcall(picker._get_prompt, picker)
      if ok then
        last_picker.prompt = prompt
      end
    end
    return orig_close(prompt_bufnr)
  end

  local skip = { resume = true, pickers = true }
  local names = {}
  for name, fn in pairs(builtin) do
    if type(fn) == "function" and not skip[name] then
      names[#names + 1] = name
    end
  end

  for _, name in ipairs(names) do
    local fn = builtin[name]
    builtin[name] = function(opts)
      last_picker = {
        name = name,
        opts = clone_opts(opts),
        gen = (last_picker and last_picker.gen or 0) + 1,
      }
      pending_gen = last_picker.gen
      local ok, err = xpcall(function()
        fn(opts)
      end, debug.traceback)
      pending_gen = 0
      if not ok then
        error(err, 0)
      end
    end
  end

  local orig_resume = builtin.resume
  function builtin.resume(opts)
    if not last_picker or (opts and opts.cache_index and opts.cache_index ~= 1) then
      return orig_resume(opts)
    end
    local call_opts = clone_opts(last_picker.opts) or {}
    if last_picker.prompt ~= nil then
      call_opts.default_text = last_picker.prompt
    end
    return builtin[last_picker.name](call_opts)
  end
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
      install_resume_redo()
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
