local Utils = require("gual.utils")

return function(lspconfig)
  Utils.ensure_mason_install("tailwindcss-language-server")

  lspconfig.tailwindcss.setup({})
end
