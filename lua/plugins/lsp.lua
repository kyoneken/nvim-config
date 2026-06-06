-- ========================================
-- LSP設定 - Language Server Protocol
-- ========================================

return {
  -- Mason: LSPサーバー管理
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Mason-LSPConfig: Masonとnvim-lspconfigの橋渡し
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- LSPサーバーの設定
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local function root_pattern(...)
        return lspconfig.util.root_pattern(...)
      end

      local servers = {
        bashls = {},
        eslint = {},
        jsonls = {},
        rust_analyzer = {},
        yamlls = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        ts_ls = {
          root_dir = root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
          },
        },
        kotlin_language_server = {
          root_dir = root_pattern("settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", ".git"),
        },
      }

      -- SwiftはXcode/Swift toolchain同梱のsourcekit-lspを使う
      servers.sourcekit = {
        capabilities = capabilities,
        root_dir = root_pattern("Package.swift", "*.xcodeproj", "*.xcworkspace", ".git"),
      }

      for server_name, config in pairs(servers) do
        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
        vim.lsp.config(server_name, config)
      end

      require("mason-lspconfig").setup({
        -- 自動インストールするLSPサーバー
        ensure_installed = {
          "bashls",
          "eslint",
          "gopls",
          "jsonls",
          "kotlin_language_server",
          "lua_ls",
          "pyright",
          "rust_analyzer",
          "ts_ls",
          "yamlls",
        },
        automatic_enable = true,
      })

      vim.lsp.enable("sourcekit")
    end,
  },

  -- nvim-lspconfig: LSPクライアント設定
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
  },
}
