local Utils = require("gual.utils")

return function(lspconfig)
    Utils.ensure_mason_install("html-lsp")

    lspconfig.html.setup({})
end
