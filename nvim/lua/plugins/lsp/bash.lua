local Utils = require("gual.utils")

return function(lspconfig)
    Utils.ensure_mason_install("bash-language-server")

    lspconfig.bashls.setup({})
end
