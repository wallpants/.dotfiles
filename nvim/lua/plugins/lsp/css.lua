local Utils = require("gual.utils")

return function(lspconfig)
  Utils.ensure_mason_install("css-lsp")

  lspconfig.cssls.setup({})
end
