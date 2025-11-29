-- ========================================
-- Git統合プラグイン
-- ========================================

return {
  -- Gitsigns: Git差分表示
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- ナビゲーション
          map("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, { expr = true, desc = "次の変更箇所" })

          map("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, { expr = true, desc = "前の変更箇所" })

          -- アクション
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Hunkをステージ" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Hunkをリセット" })
          map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "選択範囲をステージ" })
          map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "選択範囲をリセット" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "バッファ全体をステージ" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "ステージを取り消し" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "バッファ全体をリセット" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Hunkをプレビュー" })
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "行のBlame表示" })
          map("n", "<leader>hd", gs.diffthis, { desc = "Diff表示" })
        end,
      })
    end,
  },

  -- Fugitive: Git操作
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite" },
    keys = {
      { "<leader>gG", "<cmd>Git<cr>", desc = "Git status" },
    },
  },

  -- LazyGit: TUIのGitクライアント統合
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit起動" },
    },
  },
}
