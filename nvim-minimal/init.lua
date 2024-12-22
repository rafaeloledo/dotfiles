-- declare as global function to modularize files
add_to_pkgpath = function(path)
  -- add a path to package path
  -- preprending the nvim folder to the new path
  package.path = package.path .. ";/home/rgnh55/.config/nvim/" .. path
end

-- add nvim root folder to require
-- it can now search for ordinary root files like init.lua, foo.lua
-- more information :h require()/package.path
add_to_pkgpath("?.lua")

require("opts")
require("keymaps")
require("color")
require("file-manager")
require("treesitter")
