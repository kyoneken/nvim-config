# 基本操作

リーダーは `<Space>`。

## 起動と終了

```bash
nvim ファイル
nvim .
nvim フォルダ
```

| キー / コマンド | 動作 |
| --- | --- |
| `<Space>w` / `:w` | 保存 |
| `<Space>q` / `:q` | 閉じる |
| `:q!` | 保存せずに閉じる |
| `:wq` | 保存して閉じる |

## フォルダ

`nvim .` と `nvim <フォルダ>` は、そのディレクトリを oil で開く。

| キー | 動作 |
| --- | --- |
| `Enter` | ファイルを開く。ディレクトリなら中へ |
| `-` | 親ディレクトリ。ファイルを開いているときも、そのファイルのディレクトリを開く |
| `g?` | oil のヘルプ |

## ファイル名と検索

| キー | 動作 |
| --- | --- |
| `<Space>ff` | ファイル名（fzf-lua） |
| `<Space>fg` | 文字列検索（ripgrep） |
| `/単語` | 今のファイル内を検索 |
| `n` / `N` | 次 / 前 |
| `Esc` | 検索ハイライトを消す |

fzf の中では `Enter` で開く。`Esc` で閉じる。

## LSP

言語サーバーは PATH にあれば、対応するファイルを開いたときに付く。状態は `<Space>li` または `:checkhealth vim.lsp`。

| キー | 動作 |
| --- | --- |
| `gd` | 定義 |
| `K` | ホバー |
| `grr` | 参照 |
| `grn` / `<Space>lr` | リネーム |
| `gra` / `<Space>la` | コードアクション |
| `<Space>lf` | フォーマット |
| `[d` / `]d` | 前 / 次の診断 |
| `<Space>dq` | 診断をロケーションリストへ（`:lopen`） |

補完は組み込み。候補が出たら `Ctrl-y` で確定、`Ctrl-n` / `Ctrl-p` で移動、`Ctrl-e` で閉じる。

## Git

画面左のサインが gitsigns。

| キー | 動作 |
| --- | --- |
| `]c` / `[c` | 次 / 前の変更 |
| `<Space>hs` / `<Space>hr` | 変更をステージ / 戻す |
| `<Space>hp` | プレビュー |
| `<Space>hb` | blame |
| `<Space>hd` | diff |

## ウィンドウとバッファ

| キー | 動作 |
| --- | --- |
| `Ctrl-h/j/k/l` | ウィンドウ移動 |
| `Shift-h` / `Shift-l` | 前 / 次のバッファ |
| `<Space>x` | バッファを閉じる |

## シンタックス

ハイライトは `vim.treesitter.start()`。パーサーは nvim-treesitter（main）が入っている言語と、Neovim 同梱のパーサー。選択中に `Ctrl-Space` で親ノード、`Backspace` で子ノード。

## 詰まったとき

```vim
:checkhealth
:Lazy sync
:LspLog
```
