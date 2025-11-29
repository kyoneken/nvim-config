# Copilot Instructions for Neovim

## 環境設定
- **言語**: 日本語環境のユーザ向け
- **エディタ**: Neovim (最新版を想定)
- **年**: 2025年の最新トレンドに対応

## コーディングスタイル

### 全般
- コメントは日本語で記述
- 変数名・関数名は英語を使用し、わかりやすく自己説明的な命名を心がける
- モダンな構文とベストプラクティスを優先

### Lua設定
- Neovimの設定は基本的にLuaで記述
- `init.lua` への移行を推奨(現在 `init.vim` を使用している場合)
- モジュール化された設定構造を採用

## 2025年のトレンド

### プラグイン管理
- **lazy.nvim**: 遅延読み込みに優れた最新のプラグインマネージャー
- 使わないプラグインは積極的に削除し、軽量化を図る

### 推奨プラグイン構成

#### コア機能
- **nvim-treesitter**: 高度なシンタックスハイライトとコード理解
- **telescope.nvim**: ファジーファインダー(fzf-luaも選択肢)
- **nvim-lspconfig**: LSPクライアント設定
- **mason.nvim**: LSPサーバー、DAP、リンター、フォーマッターの統合管理

#### 補完・AI支援
- **nvim-cmp**: モダンな補完エンジン
- **GitHub Copilot**: AI支援コーディング(既に導入済み)
- **copilot-cmp**: CopilotとCMPの統合

#### UI/UX
- **lualine.nvim** または **heirline.nvim**: ステータスライン
- **neo-tree.nvim** または **oil.nvim**: ファイルエクスプローラー
- **noice.nvim**: モダンなUI改善
- **which-key.nvim**: キーバインドヘルパー

#### Git統合
- **lazygit.nvim**: LazyGitとの統合
- **gitsigns.nvim**: Gitの差分表示(vim-gitgutterの後継)
- **vim-fugitive**: Git操作(既に導入済み)

#### 開発体験向上
- **trouble.nvim**: 診断・参照の一覧表示
- **nvim-dap**: デバッグアダプタープロトコル
- **conform.nvim**: 高速なフォーマッター
- **nvim-lint**: 非同期リンター

### キーバインド哲学
- `<leader>` キーを活用(通常はスペースキー)
- `which-key.nvim` で発見可能性を高める
- 論理的なグルーピング:
  - `<leader>f`: ファイル/検索系
  - `<leader>g`: Git操作
  - `<leader>l`: LSP操作
  - `<leader>d`: デバッグ
  - `<leader>c`: コード操作

### パフォーマンス重視
- 起動時間は50ms以下を目指す
- 遅延読み込みを積極的に活用
- 不要なプラグインは削除
- `:checkhealth` で定期的に健全性をチェック

### モダンな機能
- **Treesitter**: AST基盤のコード操作
- **LSP**: 言語サーバーによるインテリセンス
- **DAP**: 統合デバッグ環境
- **Floating Windows**: モダンなUI要素の活用
- **Lua API**: VimScriptではなくLuaでの設定

## ファイル構成例
```
~/.config/nvim/
├── init.lua              # エントリーポイント
├── copilot-instructions.md
├── lua/
│   ├── config/
│   │   ├── options.lua   # Vim オプション設定
│   │   ├── keymaps.lua   # キーマッピング
│   │   ├── autocmds.lua  # 自動コマンド
│   │   └── lazy.lua      # lazy.nvim 設定
│   └── plugins/
│       ├── treesitter.lua
│       ├── lsp.lua
│       ├── cmp.lua
│       ├── telescope.lua
│       ├── git.lua
│       └── ui.lua
```

## コード生成時の注意
- エラーハンドリングを適切に実装
- 非同期処理を優先
- ドキュメントコメントを適切に追加
- パフォーマンスを考慮したコード
- Neovim 0.9+ の機能を活用

## AI支援の活用
- Copilotの提案を積極的に活用
- ボイラープレートコードの自動生成
- リファクタリングの支援
- テストコードの生成

## 参考リソース
- [Neovim公式ドキュメント](https://neovim.io/doc/)
- [awesome-neovim](https://github.com/rockerBOO/awesome-neovim)
- [LazyVim](https://www.lazyvim.org/) - 設定の参考に
