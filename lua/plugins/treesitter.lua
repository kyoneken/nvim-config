local external_parsers = {
  "bash",
  "diff",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "html",
  "javascript",
  "json",
  "kdl",
  "kotlin",
  "python",
  "regex",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "yaml",
}

return {
  "neovim-treesitter/nvim-treesitter",
  dependencies = {
    "neovim-treesitter/treesitter-parser-registry",
  },
  lazy = false,
  build = ":TSUpdate",
  init = function()
    require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
      local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
      local filename = vim.fn.fnamemodify(filepath, ":t")
      return string.match(filename, ".*mise.*%.toml$") ~= nil
    end, { force = true, all = false })
  end,
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup({})
    treesitter.install(external_parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NvimTreesitterStart", { clear = true }),
      callback = function(event)
        local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
        if lang and vim.treesitter.language.add(lang) then
          vim.treesitter.start(event.buf, lang)
        end
      end,
    })

    vim.keymap.set({ "n", "x" }, "<C-space>", function()
      vim.treesitter.select("parent")
    end, { desc = "構文ノードを拡張選択" })

    vim.keymap.set("x", "<BS>", function()
      vim.treesitter.select("child")
    end, { desc = "構文ノードの選択を縮小" })
  end,
}
