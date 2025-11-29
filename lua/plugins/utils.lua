-- ========================================
-- その他の便利なプラグイン
-- ========================================

return {
  -- Comment.nvim: コメント切替
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "行コメント切替" },
      { "gc", mode = { "n", "v" }, desc = "コメント切替" },
    },
    config = function()
      require("Comment").setup()
    end,
  },

  -- Autopairs: 括弧の自動補完
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- Treesitterを使用
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
        },
      })
      
      -- cmpとの統合
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Surround: 囲み文字の操作
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Toggleterm: ターミナル統合
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "ターミナル切替" },
    },
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = "horizontal", -- horizontal, vertical, float, tab
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
        },
      })
    end,
  },

  -- Todo-comments: TODOハイライト
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        signs = true,
        keywords = {
          FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        },
      })
    end,
  },

  -- Vim-commentary (既存のものを維持)
  {
    "tpope/vim-commentary",
    event = "VeryLazy",
  },

  -- Mini.nvim: 便利な小機能集
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      -- mini.ai: テキストオブジェクト拡張
      require("mini.ai").setup()
      
      -- mini.move: 行やブロックの移動
      require("mini.move").setup()
      
      -- mini.pairs: 括弧の自動補完（autopairsを使う場合はコメントアウト）
      -- require("mini.pairs").setup()
    end,
  },
}
