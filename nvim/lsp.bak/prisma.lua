local Utils = require("gual.utils")

return function(lspconfig)
    Utils.ensure_mason_install("prisma-language-server")

    lspconfig.prismals.setup({})
end
