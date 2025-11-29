# Neovim 設定ドキュメント

このディレクトリには、Neovimの使い方や設定に関するドキュメントが含まれています。

## ドキュメント一覧

### 📚 [basic-usage.md](./basic-usage.md)
**Neovim 基本操作ガイド** - 初心者向け

以下の内容を網羅しています:
- 起動と終了
- モード切替（Normal/Insert/Visual）
- ファイル操作とNeo-tree
- 検索機能（Telescope）
- コード編集の基本
- Git操作（Gitsigns、LazyGit）
- LSP機能（定義ジャンプ、補完など）
- Copilot機能
- プラグイン管理
- トラブルシューティング

**推奨**: まずこのドキュメントから読み始めてください。

---

## 設定ファイル構造

```
~/.config/nvim/
├── init.lua                          # メインエントリーポイント
├── copilot-instructions.md           # Copilot向けの指示
├── doc/                              # ドキュメント（このディレクトリ）
│   ├── README.md                     # このファイル
│   └── basic-usage.md                # 基本操作ガイド
├── lua/
│   ├── config/                       # 基本設定
│   │   ├── lazy.lua                  # lazy.nvimブートストラップ
│   │   ├── options.lua               # Vimオプション設定
│   │   ├── keymaps.lua               # キーマッピング
│   │   └── autocmds.lua              # 自動コマンド
│   └── plugins/                      # プラグイン設定
│       ├── colorscheme.lua           # カラースキーム
│       ├── treesitter.lua            # シンタックスハイライト
│       ├── lsp.lua                   # LSP設定
│       ├── cmp.lua                   # 補完設定
│       ├── telescope.lua             # ファジーファインダー
│       ├── neo-tree.lua              # ファイルエクスプローラー
│       ├── git.lua                   # Git統合
│       ├── ui.lua                    # UI関連
│       ├── copilot.lua               # Copilot設定
│       └── utils.lua                 # その他便利プラグイン
└── pack/                             # 旧vim-plug形式プラグイン（未使用）
```

---

## クイックスタート

### 1. 初回起動
```bash
nvim
```
初回起動時、lazy.nvimが自動的にすべてのプラグインをインストールします。

### 2. 健全性チェック
```vim
:checkhealth
```
システムに不足している依存関係がないか確認します。

### 3. 基本操作を試す
1. `<Space>ff` でファイル検索を開く
2. `<Space>e` でファイルツリーを開く
3. ファイルを編集してみる
4. `<Space>gg` でLazyGitを開く

---

## 重要なキーバインド

### リーダーキー
`<Space>` がリーダーキーです。`<Space>` を押すと、Which-keyが利用可能なコマンドを表示します。

### よく使うショートカット
| キー | 説明 |
|------|------|
| `<Space>ff` | ファイル検索 |
| `<Space>fg` | テキスト検索 |
| `<Space>e` | ファイルツリー |
| `<Space>gg` | LazyGit |
| `<Space>w` | 保存 |
| `<Space>q` | 終了 |

詳細は [basic-usage.md](./basic-usage.md) を参照してください。

---

## プラグイン一覧

### コア機能
- **lazy.nvim** - プラグインマネージャー
- **nvim-treesitter** - 高度なシンタックスハイライト
- **telescope.nvim** - ファジーファインダー
- **mason.nvim** - LSPサーバー管理
- **nvim-lspconfig** - LSP設定
- **nvim-cmp** - 補完エンジン

### UI/UX
- **tokyonight.nvim** - カラースキーム
- **lualine.nvim** - ステータスライン
- **bufferline.nvim** - タブライン
- **neo-tree.nvim** - ファイルエクスプローラー
- **which-key.nvim** - キーバインドヘルパー
- **noice.nvim** - モダンなUI
- **alpha-nvim** - スタート画面

### Git統合
- **gitsigns.nvim** - Git差分表示
- **vim-fugitive** - Git操作
- **lazygit.nvim** - LazyGit統合

### AI支援
- **copilot.vim** - GitHub Copilot
- **CopilotChat.nvim** - AIチャット

### その他
- **Comment.nvim** - コメント切替
- **nvim-autopairs** - 括弧自動補完
- **nvim-surround** - 囲み文字操作
- **toggleterm.nvim** - ターミナル統合
- **trouble.nvim** - 診断一覧
- **todo-comments.nvim** - TODOハイライト

---

## トラブルシューティング

### プラグインがインストールされない
```vim
:Lazy sync
```

### LSPが動作しない
1. LSPサーバーがインストールされているか確認:
   ```vim
   :Mason
   ```
2. LSPログを確認:
   ```vim
   :LspLog
   ```
3. LSPを再起動:
   ```vim
   :LspRestart
   ```

### 設定を元に戻したい
```bash
cd ~/.config/nvim
mv init.lua init.lua.new
mv init.vim.backup init.vim
mv lua/copilot-config.lua.backup lua/copilot-config.lua
```

---

## さらに詳しく

- **基本操作**: [basic-usage.md](./basic-usage.md)
- **Copilot指示**: [../copilot-instructions.md](../copilot-instructions.md)
- **設定ファイル**: `lua/config/` と `lua/plugins/` を参照

---

質問や問題があれば、`:help` コマンドでNeovimの組み込みヘルプを参照してください。
