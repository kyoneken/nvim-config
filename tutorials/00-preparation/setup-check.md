# 第0章: 準備編 🛠️

このチュートリアルを始める前に、環境が正しくセットアップされているか確認しましょう。

---

## ✅ チェックリスト

### 1. Neovimのバージョン確認

```bash
nvim --version
```

**必要なバージョン**: 0.9.0以上

出力例:
```
NVIM v0.10.0
Build type: Release
```

---

### 2. 設定ファイルの確認

Neovimを起動して、以下のコマンドを実行:

```vim
:echo stdpath('config')
```

`~/.config/nvim` が表示されればOK

---

### 3. プラグインのインストール確認

```vim
:Lazy
```

Lazy UIが開き、すべてのプラグインがインストール済み（緑色のチェックマーク）になっていればOK。

もし未インストールのプラグインがあれば:
```vim
:Lazy sync
```

---

### 4. LSPサーバーの確認

```vim
:Mason
```

Mason UIが開き、以下がインストールされていることを確認:
- `lua_ls` (Lua)
- `pyright` (Python)
- `ts_server` (TypeScript/JavaScript)

インストールされていなければ、Mason UI内で:
1. `/lua_ls` で検索
2. `i` キーでインストール

---

### 5. 健全性チェック

```vim
:checkhealth
```

エラーがないか確認してください。

主なチェック項目:
- ✅ Python3 provider
- ✅ Node.js provider
- ✅ Clipboard support
- ✅ LSP

**警告が出ても問題ない場合が多いです**。エラー（ERROR）がなければOK。

---

### 6. 依存ツールの確認

ターミナルで以下を実行:

```bash
# ripgrep（テキスト検索用）
rg --version

# lazygit（Git操作用、オプション）
lazygit --version

# Node.js（Copilot用）
node --version
```

**ripgrepがない場合:**
```bash
brew install ripgrep
```

**lazygitがない場合（オプション）:**
```bash
brew install lazygit
```

---

## 🎨 見た目の確認

### カラースキームのテスト

Neovimを起動して、以下が表示されればOK:
- 美しいスタート画面（Alpha）
- 下部にステータスライン（Lualine）
- 上部にタブライン（Bufferline）

何か開いてみましょう:
```vim
:e ~/.config/nvim/init.lua
```

シンタックスハイライトがきれいに表示されていればOK！

---

## 🔧 トラブルシューティング

### エラーが出る場合

1. **プラグインの再インストール**
   ```vim
   :Lazy clean
   :Lazy sync
   ```

2. **LSPサーバーの再インストール**
   ```vim
   :Mason
   # UIでサーバーを選択して `X` で削除、`i` で再インストール
   ```

3. **設定の再読み込み**
   ```vim
   :source ~/.config/nvim/init.lua
   ```

4. **Neovimの再起動**
   一度終了して、もう一度起動

---

## ✨ オプション設定

### Nerd Fontの確認

アイコンが正しく表示されるか確認:

```vim
:e ~/.config/nvim/lua/plugins/neo-tree.lua
```

ファイルツリーを開く:
```
<Space>e
```

アイコン（📁 📄 など）が表示されていればOK。

**表示されない場合:**
1. [Nerd Fonts](https://www.nerdfonts.com/)をインストール
2. ターミナルのフォント設定を変更

```bash
# 例: JetBrains Mono Nerd Font
brew install --cask font-jetbrains-mono-nerd-font
```

---

## 📝 練習: 基本操作の確認

### ステップ1: ファイルを開く

```vim
:e test.txt
```

### ステップ2: Insertモードに入る

```
i
```

### ステップ3: テキストを入力

```
Hello, Neovim!
これはテストです。
```

### ステップ4: Normalモードに戻る

```
ESC
```

### ステップ5: 保存して終了

```
:wq
```

これができれば準備完了です！ 🎉

---

## 🎯 準備完了チェック

- [ ] Neovim 0.9.0以上がインストール済み
- [ ] すべてのプラグインがインストール済み
- [ ] LSPサーバーが最低1つインストール済み
- [ ] `:checkhealth` でエラーなし
- [ ] カラースキームが正しく表示される
- [ ] ファイルの作成・保存・終了ができる

すべてチェックできたら、**[第1章: 基本操作](../01-basics/)** に進みましょう！ 🚀

---

**困ったときは**: [トラブルシューティング](../doc/basic-usage.md#トラブルシューティング) を参照してください。
