local Utils = require("gual.utils")

return function(lspconfig)
  Utils.ensure_mason_install("marksman")

  lspconfig.marksman.setup({})
end
