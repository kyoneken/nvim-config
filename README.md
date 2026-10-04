# Neovim 設定

ファイルを名前で開く、フォルダをエクスプローラーで開く、シンタックスハイライト、LSP。

リーダーは `<Space>`。

## キー

| キー | 動作 |
| --- | --- |
| `<Space>ff` | ファイル名で開く（fzf-lua） |
| `<Space>fg` | 文字列検索（fzf-lua、ripgrep） |
| `-` | 今のファイルのディレクトリを開く（oil） |
| `gd` | 定義へ |
| `K` | ホバー |
| `grr` | 参照 |
| `grn` | リネーム |
| `gra` | コードアクション |
| `<Space>lr` | リネーム |
| `<Space>la` | コードアクション |
| `<Space>lf` | フォーマット |
| `<Space>li` | LSP の状態 |
| `[d` / `]d` | 前 / 次の診断 |
| `<Space>dq` | 診断をロケーションリストへ（`:lopen`） |
| `]c` / `[c` | 次 / 前の変更（gitsigns） |
| `<Space>hs` / `<Space>hr` | 変更をステージ / 戻す |
| `<Space>hp` | 変更をプレビュー |
| `<Space>hb` / `<Space>hd` | blame / diff |
| `<Space>w` / `<Space>q` | 保存 / 閉じる |
| `<Space>x` | バッファを閉じる |
| `Shift-h` / `Shift-l` | 前 / 次のバッファ |
| `Ctrl-h/j/k/l` | ウィンドウ移動 |
| `Ctrl-Space` / `Backspace`（選択中） | 構文ノードを広げる / 戻す |

補完は Neovim 組み込み。メニューが出たら `Ctrl-y` で確定する。`Ctrl-e` で閉じる。

## フォルダを開く

```bash
nvim .
nvim <フォルダ>
```

そのフォルダを oil.nvim で開く。`Enter` でファイルか中のフォルダを開き、`-` で親へ戻る。ファイルを開いているときに `-` を押すと、そのファイルがあるディレクトリに戻り、別のファイルへ移れる。

## 入っているもの

- 検索: fzf-lua（`fzf` と `ripgrep`）
- エクスプローラー: oil.nvim
- ハイライト: `vim.treesitter` と nvim-treesitter（main）
- LSP: Neovim 組み込みと nvim-lspconfig。言語サーバーは PATH に置く
- Git の差分: gitsigns のみ
- 色: tokyonight

対象は Swift、Python、Go、JavaScript / TypeScript、Kotlin。加えて Lua、Rust、Bash、JSON、YAML。

Neovim 0.12 以上。`<Space>ff` と `<Space>fg` には `fzf` と `ripgrep` が PATH にあること。パーサーを入れるには `tree-sitter` コマンド 0.26 以上と C コンパイラ。Homebrew ではそのコマンドは `tree-sitter-cli` から入る。`tree-sitter` という formula はライブラリだけで、コマンドは入らない。

```bash
brew install fzf ripgrep tree-sitter-cli
```

```bash
git clone https://github.com/kyoneken/nvim-config.git ~/.config/nvim
nvim
```

履歴が要らないときは [Releases](https://github.com/kyoneken/nvim-config/releases) の `nvim-config-vX.Y.Z.zip` を展開し、中の `nvim-config-vX.Y.Z` を `~/.config/nvim` にする。中身はそのタグ時点のファイル一式で、Git の履歴は入っていない。

初回起動でプラグインが入る。詳しいキーは [doc/basic-usage.md](doc/basic-usage.md)。
