-- ========================================
-- fzf-lua - ファイル名と文字列検索
-- ========================================

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "ファイル検索" },
    { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "テキスト検索" },
  },
}
