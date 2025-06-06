return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "c",
        "markdown",
        "markdown_inline",
        "go",
        "json",
        "toml",
        "cpp",
        "dockerfile",
        "bash",
      },
      indent = {
        enable = true,
        -- disable = {
        --   "python"
        -- },
      },
    },
  },

  {
    "tpope/vim-surround",
    event = "VeryLazy"
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make", -- This is Optional, only if you want to use tiktoken_core to calculate tokens count
    opts = {
      provider = "copilot",
      providers = {
        copilot = {
          -- model = "gemini-2.5-pro",
          model = "claude-sonnet-4",
          -- max_tokens = 90000,
        },
      },
      -- rag_service = {
      --   enabled = true,                         -- Enables the RAG service
      --   host_mount = "/Users/arturhnat/Coding", -- Host mount path for the rag service
      --   provider = "openai",                    -- The provider to use for RAG service (e.g. openai or ollama)
      --   llm_model = "",                         -- The LLM model to use for RAG service
      --   embed_model = "",                       -- The embedding model to use for RAG service
      --   endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
      -- },
      custom_tools = {
        {
          name = "run_go_tests",                                -- Unique name for the tool
          description = "Run Go unit tests and return results", -- Description shown to AI
          command = "go test -v -cover ./...",                  -- Shell command to execute
          param = {                                             -- Input parameters (optional)
            type = "table",
            fields = {
              {
                name = "target",
                description = "Package or directory to test (e.g. './pkg/...' or './internal/pkg')",
                type = "string",
                optional = true,
              },
            },
          },
          returns = { -- Expected return values
            {
              name = "result",
              description = "Result of the call",
              type = "string",
            },
            {
              name = "error",
              description = "Error message if the call was not successful",
              type = "string",
              optional = true,
            },
          },
          func = function(params, on_log, on_complete) -- Custom function to execute
            local target = params.target or "./..."
            return vim.fn.system(string.format("go test -v -cover %s", target))
          end,
        },
        {
          name = "check_nodejs_syntax",                                      -- Unique name for the tool
          description = "Check Node.js/JavaScript syntax without executing", -- Description shown to AI
          command = "node -c",                                               -- Shell command to execute
          param = {                                                          -- Input parameters (optional)
            type = "table",
            fields = {
              {
                name = "file",
                description = "JavaScript file to check syntax for (e.g. 'index.js' or 'src/app.js')",
                type = "string",
                optional = false,
              },
            },
          },
          returns = { -- Expected return values
            {
              name = "result",
              description = "Result of the syntax check",
              type = "string",
            },
            {
              name = "error",
              description = "Error message if syntax check failed",
              type = "string",
              optional = true,
            },
          },
          func = function(params, on_log, on_complete) -- Custom function to execute
            local file = params.file
            if not file then
              return "Error: file parameter is required"
            end
            local result = vim.fn.system(string.format("node -c %s", vim.fn.shellescape(file)))
            local exit_code = vim.v.shell_error
            if exit_code == 0 then
              return string.format("Syntax check passed for %s", file)
            else
              return result
            end
          end,
        },
      }
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- for providers='copilot'
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
}
