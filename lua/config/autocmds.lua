-- ========================================
-- 自動コマンド設定
-- ========================================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- 保存時に末尾の空白を削除
autocmd("BufWritePre", {
  group = augroup("TrimWhitespace", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- ヤンク時にハイライト
autocmd("TextYankPost", {
  group = augroup("HighlightYank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- ファイルを開いた時に最後のカーソル位置に移動
autocmd("BufReadPost", {
  group = augroup("RestoreCursor", { clear = true }),
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ターミナルモードでは行番号を非表示
autocmd("TermOpen", {
  group = augroup("Terminal", { clear = true }),
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- LSPアタッチ時のキーマップ
autocmd("LspAttach", {
  group = augroup("LspKeymaps", { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  end,
})
