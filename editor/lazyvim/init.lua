-- Carrega detecção de VSCode
local vscode = require("config.vscode")

-- Carrega sempre
require("config.lazy")
require("config.keymaps")

-- Carrega apenas fora do VSCode
if not vscode.is_vscode() then
  require("config.neovide")
  require("config.base")
end
