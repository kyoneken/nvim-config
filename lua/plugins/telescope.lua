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
    { "<leader>fp", "<cmd>Telescope git_files<cr>", desc = "Git管理ファイル検索" },
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
        prompt_prefix = "󰭎 ",
        selection_caret = "➜ ",
        path_display = { "truncate" },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!**/.git/*",
        },
        file_ignore_patterns = {
          "%.git/",
          "%.gradle/",
          "%.idea/",
          "%.next/",
          "%.swiftpm/",
          "%.venv/",
          "DerivedData/",
          "Pods/",
          "build/",
          "dist/",
          "node_modules/",
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
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--glob=!**/.git/*",
            "--glob=!**/node_modules/*",
            "--glob=!**/.venv/*",
            "--glob=!**/Pods/*",
            "--glob=!**/DerivedData/*",
            "--glob=!**/.gradle/*",
            "--glob=!**/build/*",
            "--glob=!**/dist/*",
            "--glob=!**/target/*",
          },
        },
        git_files = {
          hidden = true,
          show_untracked = true,
          use_git_root = true,
        },
        live_grep = {
          additional_args = function()
            return { "--hidden", "--glob=!**/.git/*" }
          end,
        },
        buffers = {
          sort_mru = true,
          ignore_current_buffer = true,
        },
      },
    })

    -- fzf-native拡張の読み込み
    telescope.load_extension("fzf")
  end,
}
