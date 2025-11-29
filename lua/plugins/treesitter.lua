-- ========================================
-- Treesitter設定 - 高度なシンタックスハイライト
-- ========================================

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- 自動インストールする言語
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      
      -- 自動インストールを有効化
      auto_install = true,
      
      -- ハイライトを有効化
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      
      -- インデントを有効化
      indent = {
        enable = true,
      },
      
      -- インクリメンタルセレクション
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      
      -- テキストオブジェクト
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    })
  end,
}
