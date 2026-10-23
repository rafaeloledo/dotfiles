local M = {}

local ns = vim.api.nvim_create_namespace("mini_files_git")
local cache = {}
local in_flight = {}
local cache_timeout = 2000 -- ms

local priority = {
  ["!"] = 6, -- conflict
  ["•"] = 5, -- modified
  ["+"] = 4, -- added
  ["→"] = 3, -- renamed
  ["?"] = 2, -- untracked
  ["-"] = 1, -- deleted
}

local function hl_or(preferred, fallback)
  local hl = vim.api.nvim_get_hl(0, { name = preferred })
  if not vim.tbl_isempty(hl) then
    return preferred
  end
  return fallback
end

local function get_git_root(path)
  local real = vim.uv.fs_realpath(path) or path
  return vim.fs.root(real, ".git")
end

local function status_to_sign(status)
  if not status then
    return nil
  end
  if status:match("U") or status:match("AA") or status:match("DD") then
    return "!", hl_or("DiagnosticError", "ErrorMsg")
  elseif status:match("M") then
    return "•", hl_or("GitSignsChange", "MiniDiffSignChange")
  elseif status:match("A") then
    return "+", hl_or("GitSignsAdd", "MiniDiffSignAdd")
  elseif status:match("R") then
    return "→", hl_or("GitSignsChange", "MiniDiffSignChange")
  elseif status:match("D") then
    return "-", hl_or("GitSignsDelete", "MiniDiffSignDelete")
  elseif status:match("%?") then
    return "?", hl_or("GitSignsAdd", "MiniDiffSignAdd")
  end
  return nil
end

local function parse_git_output(git_root, stdout)
  local status_map = {}
  for line in stdout:gmatch("[^\r\n]+") do
    local status = line:sub(1, 2)
    local filepath = line:sub(4)
    local arrow = filepath:find(" %-> ")
    if arrow then
      filepath = filepath:sub(arrow + 4)
    end
    filepath = filepath:gsub('^"(.*)"$', "%1")
    local abs_path = vim.fs.normalize(vim.fs.joinpath(git_root, filepath))
    local symbol, hl = status_to_sign(status)
    if symbol then
      status_map[abs_path] = { symbol = symbol, hl = hl }

      -- Propagate to parent directories up to git_root
      local current = abs_path
      while true do
        local parent = vim.fs.dirname(current)
        if not parent or parent == current or #parent < #git_root then
          break
        end
        local existing = status_map[parent]
        if not existing or (priority[symbol] or 0) > (priority[existing.symbol] or 0) then
          status_map[parent] = { symbol = symbol, hl = hl }
        end
        current = parent
      end
    end
  end
  return status_map
end

local function fetch_git_status(git_root, cb)
  local now = vim.uv.now()
  if cache[git_root] and (now - cache[git_root].time < cache_timeout) then
    cb(cache[git_root].map)
    return
  end

  if in_flight[git_root] then
    table.insert(in_flight[git_root], cb)
    return
  end

  in_flight[git_root] = { cb }

  vim.system(
    { "git", "-c", "status.relativePaths=false", "status", "--porcelain=v1", "-u" },
    { text = true, cwd = git_root },
    function(res)
      vim.schedule(function()
        local callbacks = in_flight[git_root] or {}
        in_flight[git_root] = nil

        local map = {}
        if res.code == 0 and res.stdout then
          map = parse_git_output(git_root, res.stdout)
        end

        cache[git_root] = { time = vim.uv.now(), map = map }

        for _, callback in ipairs(callbacks) do
          callback(map)
        end
      end)
    end
  )
end

local function render_signs(buf_id, status_map)
  if not vim.api.nvim_buf_is_valid(buf_id) then
    return
  end
  local mf = require("mini.files")
  vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)
  local nlines = vim.api.nvim_buf_line_count(buf_id)

  for i = 1, nlines do
    local entry = mf.get_fs_entry(buf_id, i)
    if entry then
      local real_path = vim.uv.fs_realpath(entry.path) or entry.path
      real_path = vim.fs.normalize(real_path)
      local info = status_map[real_path] or status_map[entry.path]

      if info then
        -- Sign in signcolumn
        vim.api.nvim_buf_set_extmark(buf_id, ns, i - 1, 0, {
          sign_text = info.symbol,
          sign_hl_group = info.hl,
          priority = 100,
        })

        -- Highlight entry name
        local line = vim.api.nvim_buf_get_lines(buf_id, i - 1, i, false)[1]
        if line then
          local s = line:find("/" .. vim.pesc(entry.name) .. "/?$")
          if s then
            vim.api.nvim_buf_set_extmark(buf_id, ns, i - 1, s, {
              end_col = s + #entry.name,
              hl_group = info.hl,
              priority = 100,
            })
          end
        end
      end
    end
  end
end

local function update_buffer(buf_id)
  local mf = require("mini.files")
  local entry = mf.get_fs_entry(buf_id, 1)
  local dir = entry and vim.fs.dirname(entry.path) or vim.uv.cwd()
  local git_root = get_git_root(dir)
  if not git_root then
    return
  end

  fetch_git_status(git_root, function(map)
    render_signs(buf_id, map)
  end)
end

function M.setup()
  local augroup = vim.api.nvim_create_augroup("MiniFilesGitStatus", { clear = true })

  -- Ensure signcolumn is visible across all mini.files windows
  vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = "MiniFilesWindowOpen",
    callback = function(args)
      local win_id = args.data.win_id
      if vim.api.nvim_win_is_valid(win_id) then
        vim.wo[win_id].signcolumn = "yes"
      end
    end,
  })

  -- Render git signs whenever a buffer updates
  vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = "MiniFilesBufferUpdate",
    callback = function(args)
      update_buffer(args.data.buf_id)
    end,
  })

  -- Invalidate cache on fs changes in mini.files
  vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = { "MiniFilesActionRename", "MiniFilesActionCreate", "MiniFilesActionDelete" },
    callback = function()
      cache = {}
    end,
  })

  -- Clear cache on close
  vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = "MiniFilesExplorerClose",
    callback = function()
      cache = {}
    end,
  })
end

return M
