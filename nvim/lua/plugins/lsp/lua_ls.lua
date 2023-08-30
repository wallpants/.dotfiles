local Utils = require("gual.utils")

return function(lspconfig)
  Utils.ensure_mason_install("lua-language-server")
  require("neodev").setup({})

  lspconfig.lua_ls.setup({})
end
