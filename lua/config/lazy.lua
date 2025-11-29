-- lazy.nvimのブートストラップ（自動インストール）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvimのセットアップ
require("lazy").setup("plugins", {
  defaults = {
    lazy = true, -- デフォルトで遅延読み込み
  },
  install = {
    colorscheme = { "tokyonight" }, -- フォールバックカラースキーム
  },
  checker = {
    enabled = true, -- 自動アップデートチェック
    notify = false, -- 通知は控えめに
  },
  performance = {
    rtp = {
      -- 不要なプラグインを無効化してパフォーマンス向上
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
