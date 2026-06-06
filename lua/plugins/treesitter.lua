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
  init = function()
    -- miseファイルを判定するpredicateを追加
    require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
      local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
      local filename = vim.fn.fnamemodify(filepath, ":t")
      return string.match(filename, ".*mise.*%.toml$") ~= nil
    end, { force = true, all = false })
  end,
  config = function()
    require("nvim-treesitter.configs").setup({
      -- 自動インストールする言語
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "go", -- Go言語
        "gomod", -- go.mod
        "gosum", -- go.sum
        "gowork", -- go.work
        "html",
        "javascript",
        "json",
        "kdl",
        "kotlin",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "swift",
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
