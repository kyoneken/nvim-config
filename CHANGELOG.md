# Changelog

All notable changes to this Neovim configuration will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [2.0.0] - 2025-11-29

### 🚀 Major Changes - 完全モダン化

#### Added
- **lazy.nvim**: 新しいプラグインマネージャー（vim-plugから移行）
- **完全Lua化**: init.vimからinit.luaへ完全移行
- **モジュール化**: 設定をlua/config/とlua/plugins/に分離
- **Treesitter**: 高度なシンタックスハイライトとコード解析
- **Mason.nvim**: LSPサーバー、フォーマッター、リンターの統合管理
- **Telescope.nvim**: 高性能ファジーファインダー（fzfから移行）
- **Neo-tree.nvim**: モダンなファイルエクスプローラー（NERDTreeから移行）
- **nvim-lspconfig**: ネイティブLSP設定（coc.nvimから移行）
- **nvim-cmp**: 高速な補完エンジン
- **Gitsigns.nvim**: Git差分表示とHunk操作（vim-gitgutterから移行）

#### UI/UX Improvements
- **TokyoNight**: モダンなカラースキーム
- **Lualine**: 美しいステータスライン
- **Bufferline**: タブライン追加
- **Which-key**: キーバインドヘルパー
- **Noice.nvim**: モダンなUI体験
- **Alpha.nvim**: カスタムスタート画面
- **Indent-blankline**: インデントガイド
- **Trouble.nvim**: 診断一覧表示

#### Git Integration
- **LazyGit統合**: TUI Gitクライアント
- **Gitsigns**: Hunk操作、Blame表示
- **Fugitive**: 既存のGit操作を維持

#### AI & Developer Experience
- **Copilot.vim**: GitHub Copilot統合
- **CopilotChat.nvim**: AIチャット機能（日本語対応）
- **Comment.nvim**: コメント操作強化
- **nvim-autopairs**: 括弧自動補完
- **nvim-surround**: 囲み文字操作
- **Toggleterm**: ターミナル統合
- **Todo-comments**: TODOハイライト
- **Mini.nvim**: 便利な小機能集

#### Documentation
- **copilot-instructions.md**: Copilot向けの詳細な指示
- **doc/basic-usage.md**: 包括的な基本操作ガイド
- **doc/README.md**: ドキュメント目次と設定説明

#### Configuration Structure
```
新しい構造:
~/.config/nvim/
├── init.lua                    # メインエントリーポイント
├── lua/
│   ├── config/                 # 基本設定
│   │   ├── lazy.lua           # プラグインマネージャー
│   │   ├── options.lua        # Vimオプション
│   │   ├── keymaps.lua        # キーマッピング
│   │   └── autocmds.lua       # 自動コマンド
│   └── plugins/               # プラグイン設定（モジュール化）
│       ├── colorscheme.lua
│       ├── treesitter.lua
│       ├── lsp.lua
│       ├── cmp.lua
│       ├── telescope.lua
│       ├── neo-tree.lua
│       ├── git.lua
│       ├── ui.lua
│       ├── copilot.lua
│       └── utils.lua
├── doc/                        # ドキュメント
└── copilot-instructions.md
```

### ⚡ Performance Improvements
- **起動時間の大幅短縮**: 遅延読み込みの最適化
- **メモリ使用量削減**: coc.nvimからネイティブLSPへ移行
- **非同期処理**: すべての重い処理を非同期化

### 🔧 Changed
- **プラグインマネージャー**: vim-plug → lazy.nvim
- **補完エンジン**: coc.nvim → nvim-cmp + LSP
- **ファイルエクスプローラー**: NERDTree → Neo-tree
- **ファジーファインダー**: fzf → Telescope
- **Git差分**: vim-gitgutter → Gitsigns
- **設定言語**: VimScript → Lua

### 🗑️ Removed
- vim-plug（プラグインマネージャー）
- coc.nvim（LSPクライアント）
- NERDTree（ファイルエクスプローラー）
- fzf（ファジーファインダー）
- vim-gitgutter（Git差分表示）

### 📦 Backup
- `init.vim.backup`: 旧設定ファイル
- `lua/copilot-config.lua.backup`: 旧Copilot設定

### 🐛 Bug Fixes
- **ESCキー問題**: Copilotのキーマップが`Ctrl-[`（ESC）を上書きしていた問題を修正
  - `Ctrl-]`/`Ctrl-[` → `Alt-]`/`Alt-[`に変更

### 🎯 Key Features
1. **2025年のモダンスタック**: 最新のNeovimベストプラクティスを採用
2. **完全日本語対応**: すべてのドキュメントとCopilot応答が日本語
3. **高度なコード支援**: LSP + Treesitter + Copilot
4. **Git統合**: LazyGit + Gitsigns + Fugitive
5. **発見可能性**: Which-keyによるキーバインド支援

### 📚 Default Key Bindings
- `<Space>` - リーダーキー
- `<Space>ff` - ファイル検索
- `<Space>fg` - テキスト検索
- `<Space>e` - ファイルツリー
- `<Space>gg` - LazyGit起動
- `<Space>ce/cr/cf/co/cd/ct` - CopilotChat機能
- `gd` - 定義へジャンプ
- `K` - ホバー情報
- `Ctrl-j` - Copilot提案を受け入れ

---

## [1.0.0] - 以前

### Initial Setup
- vim-plug
- coc.nvim
- NERDTree
- fzf
- copilot.vim
- CopilotChat.nvim
- vim-fugitive
- vim-gitgutter
- vim-commentary
