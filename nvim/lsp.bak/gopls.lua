local Utils = require("gual.utils")

return function(lspconfig)
    Utils.ensure_mason_install("gopls")
    local util = require("lspconfig/util")

    lspconfig.gopls.setup({
        cmd = { "gopls", "serve" },
        filetypes = { "go", "gomod" },
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
            },
        },
    })
end
