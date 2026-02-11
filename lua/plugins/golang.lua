-- ========================================
-- Go言語開発環境設定
-- ========================================

return {
  -- Go開発用のツール統合プラグイン
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        -- gofmt/goimports を保存時に自動実行
        gofmt = "gopls",
        goimports = "gopls",
        fillstruct = "gopls",
        
        -- Linter設定
        linter = "golangci-lint",
        linter_flags = {},
        
        -- テスト設定
        test_runner = "go",
        run_in_floaterm = true,
        
        -- デバッグ設定
        dap_debug = true,
        dap_debug_gui = true,
        
        -- ビルドタグ
        build_tags = "",
        
        -- その他設定
        textobjects = true,
        icons = { breakpoint = "🔴", currentpos = "🔵" },
        trouble = false,
        luasnip = true,
      })

      -- 保存時にインポートを自動整理＆フォーマット
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimports()
        end,
        group = format_sync_grp,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },

  -- Go用のスニペット
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
  },

  -- DAP（デバッグアダプタプロトコル）for Go
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        config = function()
          require("dap-go").setup()
        end,
      },
    },
  },

  -- Go用のテストランナー
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = {
      adapters = {
        ["neotest-go"] = {
          args = { "-count=1", "-timeout=60s" },
        },
      },
    },
  },
}
