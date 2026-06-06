-- ========================================
-- キーマッピング設定
-- ========================================

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ========================================
-- 基本キーマップ
-- ========================================

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

-- ========================================
-- リーダーキーマップ
-- ========================================

-- ファイル/検索系 (<leader>f)
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "ファイル検索" })
keymap.set("n", "<leader>fp", "<cmd>Telescope git_files<CR>", { desc = "Git管理ファイル検索" })
keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "テキスト検索" })
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "バッファ一覧" })
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "ヘルプ検索" })
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "最近使ったファイル" })

-- エクスプローラー
keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "ファイルツリー" })

-- Git操作 (<leader>g)
keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit起動" })
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git状態" })
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Gitコミット履歴" })
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Gitブランチ" })
keymap.set("n", "<leader>gC", "<cmd>GitConflictListQf<CR>", { desc = "Conflict一覧" })

-- LSP操作 (<leader>l)
keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "フォーマット" })
keymap.set("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP情報" })
keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "リネーム" })
keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "コードアクション" })

-- 診断 (<leader>d)
keymap.set("n", "<leader>dd", "<cmd>Trouble diagnostics toggle<CR>", { desc = "診断一覧" })
keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "診断をQuickfixへ" })

-- Go開発操作 (<leader>c - code)
keymap.set("n", "<leader>ct", "<cmd>GoTest<CR>", { desc = "[Go] テスト実行" })
keymap.set("n", "<leader>cT", "<cmd>GoTestFunc<CR>", { desc = "[Go] 関数テスト" })
keymap.set("n", "<leader>cc", "<cmd>GoCoverage<CR>", { desc = "[Go] カバレッジ" })
keymap.set("n", "<leader>cr", "<cmd>GoRun<CR>", { desc = "[Go] 実行" })
keymap.set("n", "<leader>cb", "<cmd>GoBuild<CR>", { desc = "[Go] ビルド" })
keymap.set("n", "<leader>ci", "<cmd>GoImport<CR>", { desc = "[Go] インポート追加" })
keymap.set("n", "<leader>cf", "<cmd>GoFillStruct<CR>", { desc = "[Go] 構造体補完" })
keymap.set("n", "<leader>ce", "<cmd>GoIfErr<CR>", { desc = "[Go] エラーハンドリング" })
keymap.set("n", "<leader>ca", "<cmd>GoAlt<CR>", { desc = "[Go] テストファイル切替" })
keymap.set("n", "<leader>cj", "<cmd>GoAddTag json<CR>", { desc = "[Go] JSONタグ追加" })
keymap.set("n", "<leader>cy", "<cmd>GoAddTag yaml<CR>", { desc = "[Go] YAMLタグ追加" })

-- Harpoon: よく行き来するファイル
keymap.set("n", "<leader>ha", function() require("harpoon"):list():add() end, { desc = "Harpoonに追加" })
keymap.set("n", "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, { desc = "Harpoon一覧" })
keymap.set("n", "<leader>1", function() require("harpoon"):list():select(1) end, { desc = "Harpoon 1" })
keymap.set("n", "<leader>2", function() require("harpoon"):list():select(2) end, { desc = "Harpoon 2" })
keymap.set("n", "<leader>3", function() require("harpoon"):list():select(3) end, { desc = "Harpoon 3" })
keymap.set("n", "<leader>4", function() require("harpoon"):list():select(4) end, { desc = "Harpoon 4" })

-- その他
keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "保存" })
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "閉じる" })
keymap.set("n", "<leader>x", "<cmd>bd<CR>", { desc = "バッファ削除" })

-- Lazy (プラグインマネージャー)
keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Lazy UI" })
