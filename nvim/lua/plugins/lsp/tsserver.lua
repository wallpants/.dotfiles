local Utils = require("gual.utils")

return function(lspconfig)
  Utils.ensure_mason_install("typescript-language-server")

  lspconfig.tsserver.setup({})
end
