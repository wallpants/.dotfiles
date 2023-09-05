local Utils = require("gual.utils")

return function(lspconfig)
    Utils.ensure_mason_install("pyright")

    lspconfig.pyright.setup({})
end
