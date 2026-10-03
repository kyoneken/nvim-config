-- ========================================
-- キーマッピング設定
-- ========================================

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Escでハイライトを消す
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- ウィンドウ移動
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- ウィンドウサイズ変更
keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", opts)
keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", opts)
keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- バッファ操作
keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", opts)
keymap.set("n", "<S-l>", "<cmd>bnext<CR>", opts)

-- インデント調整（ビジュアルモードで連続実行）
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- 行移動（ビジュアルモード）
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- ページスクロール時にカーソルを中央に
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- 検索時にカーソルを中央に
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

-- LSP（定義・参照の gr* は Neovim 標準のまま）
keymap.set("n", "<leader>lf", function()
  vim.lsp.buf.format()
end, { desc = "フォーマット" })
keymap.set("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP情報" })
keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "リネーム" })
keymap.set({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, { desc = "コードアクション" })
keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "診断をQuickfixへ" })

-- その他
keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "保存" })
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "閉じる" })
keymap.set("n", "<leader>x", "<cmd>bd<CR>", { desc = "バッファ削除" })
keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Lazy UI" })

keymap.set({ "n", "x" }, "<C-space>", function()
  vim.treesitter.select("parent")
end, { desc = "構文ノードを拡張選択" })

keymap.set("x", "<BS>", function()
  vim.treesitter.select("child")
end, { desc = "構文ノードの選択を縮小" })
