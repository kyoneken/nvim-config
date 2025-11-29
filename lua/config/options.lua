-- ========================================
-- Neovim 基本オプション設定
-- ========================================

local opt = vim.opt

-- シェル設定
opt.shell = "/bin/zsh"

-- インデント設定
opt.shiftwidth = 4        -- 自動インデントの幅
opt.tabstop = 4           -- タブの表示幅
opt.expandtab = true      -- タブをスペースに変換
opt.autoindent = true     -- 自動インデント
opt.smartindent = true    -- スマートインデント

-- 表示設定
opt.number = true         -- 行番号表示
opt.relativenumber = true -- 相対行番号
opt.cursorline = true     -- カーソル行をハイライト
opt.wrap = false          -- 行を折り返さない
opt.signcolumn = "yes"    -- サインカラムを常に表示
opt.colorcolumn = "80"    -- 80文字目に線を表示

-- 検索設定
opt.hlsearch = true       -- 検索結果をハイライト
opt.incsearch = true      -- インクリメンタルサーチ
opt.ignorecase = true     -- 大文字小文字を区別しない
opt.smartcase = true      -- 大文字が含まれる場合は区別

-- クリップボード設定
opt.clipboard = "unnamedplus"  -- システムクリップボードと統合

-- ファイル設定
opt.textwidth = 0         -- 自動改行なし
opt.backup = false        -- バックアップファイルを作らない
opt.swapfile = false      -- スワップファイルを作らない
opt.undofile = true       -- アンドゥ履歴を永続化
opt.autoread = true       -- 外部で変更されたら自動で読み直す

-- 編集設定
opt.mouse = "a"           -- マウス操作を有効化
opt.backspace = { "indent", "eol", "start" }  -- バックスペースの動作
opt.scrolloff = 8         -- カーソルの上下に表示する最小行数
opt.sidescrolloff = 8     -- カーソルの左右に表示する最小列数

-- UI設定
opt.termguicolors = true  -- True color対応
opt.showmode = false      -- モード表示を無効化（ステータスラインで表示）
opt.showcmd = true        -- コマンドを表示
opt.cmdheight = 1         -- コマンドラインの高さ
opt.laststatus = 3        -- グローバルステータスライン
opt.splitright = true     -- 縦分割時に右に開く
opt.splitbelow = true     -- 横分割時に下に開く

-- パフォーマンス設定
opt.updatetime = 250      -- CursorHoldイベントの発火時間
opt.timeoutlen = 300      -- キーマッピングのタイムアウト時間

-- 補完設定
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10        -- ポップアップメニューの最大高さ

-- 構文ハイライト
vim.cmd("syntax on")

-- ファイルタイプの検出
vim.cmd("filetype plugin indent on")
