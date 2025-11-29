-- ========================================
-- Telescope設定 - ファジーファインダー
-- ========================================

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "ファイル検索" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "テキスト検索" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "バッファ一覧" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "ヘルプ検索" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "最近使ったファイル" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist/",
          "build/",
          "target/",
          "%.lock",
        },
        
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<esc>"] = actions.close,
          },
          n = {
            ["q"] = actions.close,
          },
        },
      },
      
      pickers = {
        find_files = {
          hidden = true, -- 隠しファイルも表示
        },
      },
    })

    -- fzf-native拡張の読み込み
    telescope.load_extension("fzf")
  end,
}
