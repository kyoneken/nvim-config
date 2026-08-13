# Tree-sitter移行設計

## 目的

アーカイブされた `nvim-treesitter/nvim-treesitter` とそのローカル生成物を廃止し、Neovim 0.12標準のTree-sitter APIを中心とした構成へ移行する。外部言語のparserとqueryだけは、後継の `neovim-treesitter/nvim-treesitter` とcommunity registryで管理する。

## 最優先条件: 旧ローカルデータの完全削除

設定変更より前に、次の旧データを削除する。

- `~/.local/share/nvim/lazy/nvim-treesitter`
- `~/.local/share/nvim/lazy/nvim-treesitter-textobjects`
- `~/.local/share/nvim/tree-sitter-go-tmp`
- `~/.cache/nvim/luac/` 直下の、パス名に `nvim-treesitter` を含むbytecode cache

削除後に同じパスとcacheを検索し、残存物がないことを確認する。他プラグイン自身が同梱するTree-sitter WASMやqueryは、そのプラグイン固有の実装なので削除しない。

## 移行後の構成

### Neovim標準機能

- `vim.treesitter.start()` でハイライトとinjectionを有効化する。
- 構文ノードの段階的選択は `vim.treesitter.select()` を使う。
- Tree-sitterインデントは有効化せず、標準ftpluginのインデントを使う。

### Parserとqueryの管理

- `neovim-treesitter/nvim-treesitter` を常時ロードする。
- `neovim-treesitter/treesitter-parser-registry` を依存に追加する。
- 現在明示されている言語一覧からNeovim同梱parserを除き、必要な外部parserをインストールする。
- 更新には `:TSUpdate` を使う。
- `tree-sitter` CLI 0.26.1以上とCコンパイラを外部依存とする。

### 廃止する機能

- `nvim-treesitter-textobjects` を削除する。
- `af`、`if`、`ac`、`ic` のTree-sitter textobject設定を削除する。
- 旧 `require("nvim-treesitter.configs").setup()` APIを削除する。
- 旧pluginが提供していたincremental selectionとindent moduleを削除する。

### 連携プラグイン

- `otter.nvim` の依存先を後継pluginへ変更し、mise TOMLの埋め込み言語対応を維持する。
- `go.nvim` から旧pluginへの直接依存を削除する。Go parserは後継managerで提供する。
- `go.nvim` の `textobjects` は無効化し、削除した旧APIを再設定しないようにする。

## データフロー

1. lazy.nvimが後継pluginとregistryをロードする。
2. 後継pluginが不足している外部parserと対応queryをインストールする。
3. 対応するFileTypeを開いたとき、設定が `vim.treesitter.start()` を呼ぶ。
4. Neovim標準highlighterがparserとqueryを利用する。
5. mise TOMLではローカルの `after/queries/toml/injections.scm` が埋め込み言語を検出し、Otterがその領域にLSP機能を提供する。

## エラー処理

- parserが未インストールのFileTypeではNeovim起動を失敗させず、Tree-sitter開始だけをスキップする。
- parserインストール失敗は後継pluginのstatus、log、health checkで確認可能にする。
- 外部CLIがない場合は移行を完了扱いにせず、CLI導入後にparserを再構築する。

## 検証

設定ファイル中心の移行なので、独立した一時XDGディレクトリを使った統合検証を行う。

1. 旧plugin名、旧設定API、旧textobjects依存が設定内に残っていない。
2. `tree-sitter --version` が0.26.1以上である。
3. クリーンな一時XDG環境でlazy.nvimが後継pluginとregistryを取得できる。
4. Neovimがheadless起動し、Luaエラーを出さない。
5. Go、Python、TOML、Bashのparserがロードできる。
6. LuaとGoのバッファでTree-sitter highlighterが有効になる。
7. TOMLのカスタムinjection queryがコンパイルできる。
8. `:checkhealth vim.treesitter` と後継pluginのhealth checkに致命的エラーがない。

## 非対象

- lazy.nvim自体をNeovim標準package managerへ置換しない。
- OtterやGo開発環境そのものを置換しない。
- 今回削除するtextobjectへ代替pluginを追加しない。
- Copilotなど他プラグインが同梱するTree-sitter資産を変更しない。
