-- ========================================
-- Neovim メイン設定ファイル (init.lua)
-- ========================================

-- リーダーキーを最初に設定（プラグインより前に）
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 基本設定の読み込み
require("config.options")
require("config.keymaps")

-- lazy.nvim (プラグインマネージャー)
require("config.lazy")

-- 自動コマンド
require("config.autocmds")
