-- ========================================
-- Tree-sitter - 公式 nvim-treesitter (main)
-- ハイライト自体は Neovim の vim.treesitter
-- ========================================

local parsers = {
  "bash",
  "go",
  "javascript",
  "json",
  "kotlin",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "rust",
  "swift",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- 未導入なら非同期で入れる。失敗しても起動は止めない。
    pcall(function()
      require("nvim-treesitter").install(parsers)
    end)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
      callback = function(event)
        if vim.bo[event.buf].buftype ~= "" then
          return
        end
        pcall(vim.treesitter.start, event.buf)
      end,
    })
  end,
}
