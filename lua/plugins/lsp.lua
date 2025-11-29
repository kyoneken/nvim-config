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
      require("mason-lspconfig").setup({
        -- 自動インストールするLSPサーバー
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ts_server",
          "rust_analyzer",
          "jsonls",
          "yamlls",
          "bashls",
        },
        automatic_installation = true,
      })

      -- LSPサーバーの設定
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 自動設定
      require("mason-lspconfig").setup_handlers({
        -- デフォルトハンドラー
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,

        -- Lua専用設定
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
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
          })
        end,
      })
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
