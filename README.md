# Neovim Configuration

モダンで高性能なNeovim設定 - 2025年版

![Neovim](https://img.shields.io/badge/Neovim-0.9+-green.svg)
![Lua](https://img.shields.io/badge/Lua-5.1+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-orange.svg)

## ✨ 特徴

- 🚀 **高速起動**: lazy.nvimによる最適化された遅延読み込み
- 🎨 **モダンUI**: TokyoNight + Lualine + Noice.nvim
- 💡 **強力なLSP**: Mason + nvim-lspconfigによる統合開発環境
- 🌳 **Treesitter**: AST基盤の高度なシンタックスハイライト
- 🔍 **高性能検索**: Telescopeファジーファインダー
- 🤖 **AI支援**: GitHub Copilot + CopilotChat（日本語対応）
- 🐙 **Git統合**: LazyGit + Gitsigns + Fugitive
- 📚 **完全日本語**: ドキュメントとUI表示が日本語

## 📋 必要要件

- Neovim >= 0.9.0
- Git
- Node.js（Copilot用）
- [Nerd Font](https://www.nerdfonts.com/)（アイコン表示用）
- ripgrep（Telescopeのgrep検索用）
- LazyGit（オプション、Git操作用）

### macOSでのインストール

```bash
# Neovim
brew install neovim

# 依存ツール
brew install git node ripgrep lazygit

# Nerd Font（例: JetBrains Mono）
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
```

## 🚀 インストール

### 新規インストール

```bash
# 既存の設定をバックアップ（存在する場合）
mv ~/.config/nvim ~/.config/nvim.backup

# このリポジトリをクローン
git clone <your-repo-url> ~/.config/nvim

# Neovimを起動（プラグインが自動インストールされます）
nvim
```

### 既存環境からの移行

1. 既存の設定をバックアップ
2. このリポジトリをクローン
3. 初回起動でlazy.nvimがプラグインをインストール

## 📂 ディレクトリ構造

```
~/.config/nvim/
├── init.lua                          # メインエントリーポイント
├── copilot-instructions.md           # Copilot向けの指示
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
└── doc/                              # ドキュメント
    ├── README.md                     # ドキュメント目次
    └── basic-usage.md                # 基本操作ガイド
```

## 🎮 基本操作

### リーダーキー
`<Space>` がリーダーキーです。

### よく使うキーバインド

#### ファイル操作
- `<Space>ff` - ファイル検索
- `<Space>fg` - テキスト検索
- `<Space>fb` - バッファ一覧
- `<Space>fr` - 最近使ったファイル
- `<Space>e` - ファイルツリー

#### Git操作
- `<Space>gg` - LazyGit起動
- `<Space>hp` - 変更箇所プレビュー
- `<Space>hs` - Hunkをステージ
- `]c` / `[c` - 次/前の変更箇所へ

#### LSP機能
- `gd` - 定義へジャンプ
- `gr` - 参照を表示
- `K` - ホバー情報
- `<Space>lr` - リネーム
- `<Space>la` - コードアクション
- `<Space>lf` - フォーマット

#### Copilot
- `Ctrl-j` - 提案を受け入れ
- `<Space>ce` - コード説明（選択後）
- `<Space>cr` - コードレビュー（選択後）
- `<Space>cf` - バグ修正（選択後）
- `<Space>cc` - チャット切替

詳細は [`doc/basic-usage.md`](doc/basic-usage.md) を参照してください。

## 🔧 カスタマイズ

### オプション設定
`lua/config/options.lua` で基本オプションを変更できます。

### キーマップ追加
`lua/config/keymaps.lua` にカスタムキーマップを追加できます。

### プラグイン追加
`lua/plugins/` 内に新しいファイルを作成し、lazy.nvim形式で定義します:

```lua
return {
  "author/plugin-name",
  config = function()
    -- 設定
  end,
}
```

## 📦 主要プラグイン

### コア機能
- [lazy.nvim](https://github.com/folke/lazy.nvim) - プラグインマネージャー
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - シンタックスハイライト
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - ファジーファインダー
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSPサーバー管理
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP設定
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - 補完エンジン

### UI/UX
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) - カラースキーム
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - ステータスライン
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - ファイルエクスプローラー
- [which-key.nvim](https://github.com/folke/which-key.nvim) - キーバインドヘルパー
- [noice.nvim](https://github.com/folke/noice.nvim) - モダンUI

### Git
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git差分表示
- [vim-fugitive](https://github.com/tpope/vim-fugitive) - Git操作
- [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) - LazyGit統合

### AI
- [copilot.vim](https://github.com/github/copilot.vim) - GitHub Copilot
- [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim) - AIチャット

完全なリストは [`doc/README.md`](doc/README.md) を参照してください。

## 🐛 トラブルシューティング

### 健全性チェック
```vim
:checkhealth
```

### プラグインの同期
```vim
:Lazy sync
```

### LSPサーバーの管理
```vim
:Mason
```

詳細は [`doc/basic-usage.md`](doc/basic-usage.md#トラブルシューティング) を参照してください。

## 📚 ドキュメント

- [基本操作ガイド](doc/basic-usage.md) - 包括的な使い方マニュアル
- [ドキュメント目次](doc/README.md) - 設定ファイル構造とプラグイン一覧
- [変更履歴](CHANGELOG.md) - バージョン履歴と変更内容

## 🤝 貢献

改善提案やバグ報告は、Issueまたはプルリクエストでお願いします。

## 📝 ライセンス

MIT License

## 🙏 謝辞

この設定は以下のプロジェクトやコミュニティから多くの影響を受けています:
- [LazyVim](https://www.lazyvim.org/)
- [NvChad](https://nvchad.com/)
- [AstroNvim](https://astronvim.com/)
- Neovimコミュニティ全体

---

**作成者**: [@kyoneken](https://github.com/kyoneken)  
**最終更新**: 2025年11月29日
