# 第0章: 準備

## バージョン

```bash
nvim --version
```

Neovim 0.12 以上。

## 設定の場所

```vim
:echo stdpath('config')
```

`~/.config/nvim` ならこの設定。

## プラグイン

```vim
:Lazy
```

入っていなければ `:Lazy sync`。

一覧は fzf-lua、oil.nvim、nvim-treesitter、nvim-lspconfig、gitsigns、tokyonight。

## 依存コマンド

```bash
fzf --version
rg --version
tree-sitter --version
```

`tree-sitter` は 0.26 以上。言語サーバー（gopls、pyright など）は使う言語だけ PATH に置く。

## フォルダとハイライト

```bash
nvim .
```

oil でそのディレクトリが開けばよい。Lua ファイルを開いて色が付けばハイライトは動いている。

```vim
:checkhealth
```

## 練習

```vim
:e test.txt
```

`i` で入力、`Esc`、`:wq` で保存して終了。

できたら [第1章](../01-basics/) へ。
