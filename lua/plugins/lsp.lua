-- ========================================
-- LSP - Neovim 組み込みクライアント + nvim-lspconfig
-- 補完は vim.lsp.completion（nvim-cmp は使わない）
-- ========================================

-- この設定がもともと対象にしていた言語だけ。
-- サーバー本体は PATH 上にあるものを使う。
local servers = {
  bashls = {},
  eslint = {},
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
  jsonls = {},
  kotlin_language_server = {},
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
  rust_analyzer = {},
  sourcekit = {},
  ts_ls = {
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
  yamlls = {},
}

return {
  "neovim/nvim-lspconfig",
  -- 最初のファイルは BufRead が lazy の登録より先に起きるので、起動時に有効化する
  lazy = false,
  config = function()
    local names = {}
    for name, config in pairs(servers) do
      if next(config) ~= nil then
        vim.lsp.config(name, config)
      end
      names[#names + 1] = name
    end
    table.sort(names)
    vim.lsp.enable(names)
  end,
}
