local add_to_pkgpath = function(path)
  package.path = package.path .. ";/home/rgnh55/.config/nvim/" .. path
end

add_to_pkgpath("plugins/gruvbox.nvim/lua/?.lua")
add_to_pkgpath("plugins/oil.nvim/lua/?/init.lua")
add_to_pkgpath("plugins/oil.nvim/lua/?.lua")
