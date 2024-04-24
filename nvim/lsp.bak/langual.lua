return function(lspconfig)
    vim.lsp.set_log_level(vim.lsp.log_levels.WARN)

    lspconfig.langual.setup({
        init_options = {
            -- gualberto = "casas",
        },
    })
end
