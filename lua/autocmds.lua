require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local golang_group = augroup("Golang", { clear = true })

autocmd("BufWritePre", {
  group = golang_group,
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }

    vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, result, ctx)
      if err then
        vim.notify("Error running goimports: " .. err.message, vim.log.levels.ERROR)
        return
      end

      if not result or vim.tbl_isempty(result) then return end

      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if not client then return end

      local enc = client.offset_encoding or "utf-16"

      for _, res in pairs(result) do
        if res.edit then
          vim.lsp.util.apply_workspace_edit(res.edit, enc)
        end
      end

      -- After organizing imports, format the file
      vim.lsp.buf.format({ async = true })
    end)
  end
})
