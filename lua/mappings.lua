require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("n", "<leader>fm", function()
--   require("conform").format({ async = true, lsp_fallback = true })
-- end, { desc = "Runs a formatter via conform" })

map("v", ">", ">gv", { desc = "Indents selection" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Add telescope diagnostics mapping
map("n", "<leader>tg", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope diagnostics" })
