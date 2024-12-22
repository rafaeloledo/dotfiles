local set = function(lhs, rhs)
  vim.keymap.set("n", lhs, rhs)
end

set("[b", ":bp<CR>")
set("]b", ":bn<CR>")
set("<leader>bd", ":bd<CR>")
set("<leader><leader>", ":Oil<CR>")
set("<leader>sq", ":copen<CR>")
set("[q", ":cprevious<CR>")
set("]q", ":cnext<CR>")
set("<leader>sg", ":grep ")

-- sometimes i want to only scroll and not see the cursor changing
-- position a lot of times
-- it drive me nuts

-- these are common remaps similar to vscode and browser scrolling
-- i have strong muscular memory with this
-- and for sure, again, stop changing the cursor position when scrolling !!!
set("<S-ScrollWheelUp>", "z5h")
set("<S-ScrollWheelDown>", "z5l")

-- also these help me use only on hand when i can't use both
set("<ScrollWheelUp>", "5<C-y>")
set("<ScrollWheelDown>", "5<C-e>")

-- conclusion, sometimes is good to use the mouse
-- i'm not remaping standard kbd vertical and horizontal jumps
-- because it's designed to move the cursor
-- so, when i want to only move the view, i use the mouse
