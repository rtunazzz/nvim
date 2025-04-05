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
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make", -- This is Optional, only if you want to use tiktoken_core to calculate tokens count
    opts = {
      provider = "copilot",
      cursor_applying_provider = "gemini",
      enable_cursor_planning_mode = true,
      gemini = {
        model = "gemini-2.5-pro-exp-03-25",
        max_tokens = 100000, -- use up to 100k tokens, max is 2M
      },
      -- provider = "copilot",
      copilot = {
        model = "claude-3.7-sonnet",
        -- model = "claude-3.7-sonnet-thought",
        temperature = 1,
        max_tokens = 20000,
      },
      custom_tools = {
        {
          name = "run_go_tests",                                -- Unique name for the tool
          description = "Run Go unit tests and return results", -- Description shown to AI
          command = "go test -v ./...",                         -- Shell command to execute
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
              description = "Result of the fetch",
              type = "string",
            },
            {
              name = "error",
              description = "Error message if the fetch was not successful",
              type = "string",
              optional = true,
            },
          },
          func = function(params, on_log, on_complete) -- Custom function to execute
            local target = params.target or "./..."
            return vim.fn.system(string.format("go test -v %s", target))
          end,
        },
      }
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below is optional, make sure to setup it properly if you have lazy=true
      "echasnovski/mini.pick",         -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua",              -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- for providers='copilot'
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
}
