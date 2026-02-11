-- ========================================
-- otter.nvim - LSP for embedded languages
-- ========================================
-- mise TOMLファイル内の埋め込みコードでLSPとコード補完を有効化

return {
  "jmbuhr/otter.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "toml" },
  config = function()
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = { "toml" },
      group = vim.api.nvim_create_augroup("EmbedToml", {}),
      callback = function()
        require("otter").activate()
      end,
    })
  end,
}
