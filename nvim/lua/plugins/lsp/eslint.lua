local Utils = require("gual.utils")

return function(lspconfig)
  Utils.ensure_mason_install("eslint-lsp")

  lspconfig.eslint.setup({
    settings = {
      -- helps eslint find the eslintrc
      workingDirectory = { mode = "auto" },
    },
  })
end
