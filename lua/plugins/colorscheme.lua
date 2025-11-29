-- ========================================
-- カラースキーム設定
-- ========================================

return {
  -- TokyoNight カラースキーム
  {
    "folke/tokyonight.nvim",
    lazy = false, -- 起動時にロード
    priority = 1000, -- 他のプラグインより先にロード
    config = function()
      require("tokyonight").setup({
        style = "night", -- night, storm, day, moon
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
        },
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
