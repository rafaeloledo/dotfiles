-- we need to tell nvim that require function will fetch
-- when require("gruvbox") in plugins/gruvbox.nvim/lua/gruvbox.lua
-- this work is abstracted by plugin managers
add_to_pkgpath("plugins/gruvbox.nvim/lua/?.lua")
-- require("gruvbox").load()
add_to_pkgpath("plugins/vscode.nvim/lua/?/init.lua")
add_to_pkgpath("plugins/vscode.nvim/lua/?.lua")
require("vscode").load()

