local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
local enter = vim.api.nvim_replace_termcodes("<cr>", true, true, true)

vim.api.nvim_create_augroup("LogMacro", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "LogMacro",
  pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  callback = function()
    vim.fn.setreg("l", "yo" .. enter .. "console.log('" .. esc .. "pa: ', " .. esc .. "p)")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "LogMacro",
  pattern = { "python" },
  callback = function()
    vim.fn.setreg("l", "yo" .. enter .. "print('" .. esc .. "pa: ', " .. esc .. "p)")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "LogMacro",
  pattern = { "lua" },
  callback = function()
    vim.fn.setreg("l", "yo" .. enter .. "print('" .. esc .. "pa: ', vim.inspect(" .. esc .. "p))")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "LogMacro",
  pattern = { "go" },
  callback = function()
    vim.fn.setreg("l", "yo" .. enter .. "fmt.Println('" .. esc .. "pa: ', " .. esc .. "p)")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "LogMacro",
  pattern = { "ruby" },
  callback = function()
    -- prints a label then inspects the expression
    vim.fn.setreg("l", "yo" .. enter .. "puts '" .. esc .. "pa:'; p " .. esc .. "p")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "LogMacro",
  pattern = { "php" },
  callback = function()
    vim.fn.setreg("l", "yo" .. enter .. "var_dump(" .. esc .. "p)")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "LogMacro",
  pattern = { "java" },
  callback = function()
    vim.fn.setreg("l", "yo" .. enter .. "System.out.println(\"" .. esc .. "pa: \" + " .. esc .. "p)")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "LogMacro",
  pattern = { "rust" },
  callback = function()
    vim.fn.setreg("l", "yo" .. enter .. "println!(\"{}: {:?}\", \"" .. esc .. "pa\", " .. esc .. "p)")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "LogMacro",
  pattern = { "sh", "bash" },
  callback = function()
    vim.fn.setreg("l", "yo" .. enter .. "echo \"" .. esc .. "pa: $" .. esc .. "p\"")
  end,
})


vim.api.nvim_create_autocmd("FileType", {
  group = "LogMacro",
  pattern = { "cpp" },
  callback = function()
    vim.fn.setreg("l", "yo" .. enter .. "std::cout << \"" .. esc .. "pa: \" << " .. esc .. "p << std::endl;")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "LogMacro",
  pattern = { "cs", "csharp" },
  callback = function()
    vim.fn.setreg("l", "yo" .. enter .. "Console.WriteLine(\"" .. esc .. "pa: \" + " .. esc .. "p);")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "LogMacro",
  pattern = { "zig" },
  callback = function()
    vim.fn.setreg("l", "yo" .. enter .. "std.debug.print(\"{}: {}\\n\", .{\"" .. esc .. "pa\", " .. esc .. "p})")
  end,
})
