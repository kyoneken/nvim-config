-- ========================================
-- oil.nvim - ディレクトリをエクスプローラーとして開く
-- ========================================

return {
  "stevearc/oil.nvim",
  lazy = false,
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "ディレクトリを開く" },
  },
  opts = {
    -- nvim . や :e <dir> を oil が受け取る
    default_file_explorer = true,
    -- アイコン用プラグインは足さない
    columns = {},
    view_options = {
      show_hidden = true,
    },
  },
}
