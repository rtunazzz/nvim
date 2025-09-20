-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ts_ls", "clangd", "bashls", "pyright", "dockerls", "solidity" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {})
  vim.lsp.enable(lsp)
end

-- custom LSP setups
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true, -- A stricter gofmt
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      usePlaceholders = true,
      buildFlags = { "-tags=integration" }
    },
  },
})
vim.lsp.enable("gopls")
