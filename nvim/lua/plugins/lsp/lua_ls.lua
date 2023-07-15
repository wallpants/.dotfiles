local Utils = require("gual.utils")

return function(lspconfig)
  Utils.ensure_mason_install("lua-language-server")

  lspconfig.lua_ls.setup({
    before_init = require("neodev.lsp").before_init,
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
      },
    },
  })
end
