# Tree-sitter Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the archived nvim-treesitter stack with Neovim 0.12 core APIs plus the neovim-treesitter community parser registry, starting from a verified clean local state.

**Architecture:** Neovim owns highlighting, injections, and syntax-node selection. The successor plugin only installs and updates external parsers and queries; Otter consumes the resulting language trees, while go.nvim uses Neovim's Tree-sitter API without depending on the archived plugin.

**Tech Stack:** Neovim 0.12.4, Lua, lazy.nvim, neovim-treesitter/nvim-treesitter, neovim-treesitter/treesitter-parser-registry, tree-sitter CLI 0.26.1+

## Global Constraints

- Old nvim-treesitter plugin directories, parsers, build directories, and bytecode caches must be absent before migration begins.
- Do not delete Tree-sitter assets owned by Copilot or unrelated plugins.
- Do not restore `nvim-treesitter-textobjects` or its `af`, `if`, `ac`, and `ic` mappings.
- Do not enable the successor plugin's experimental Tree-sitter indentation.
- Preserve the user's pre-existing uncommitted changes in `README.md` and `doc/basic-usage.md`.
- Do not replace lazy.nvim, Otter, or the Go development environment.

---

### Task 1: Establish prerequisites and executable acceptance checks

**Files:**
- Verify: `/Users/kyoneken/.local/share/nvim/lazy/`
- Verify: `/Users/kyoneken/.cache/nvim/luac/`
- Modify externally: `~/.config/mise/config.toml` through `mise use -g`

**Interfaces:**
- Consumes: the cleanup paths listed in the design spec
- Produces: `tree-sitter` CLI 0.26.1+ on `PATH`; a clean starting state for plugin installation

- [ ] **Step 1: Re-run the cleanup acceptance check**

```bash
test ! -e /Users/kyoneken/.local/share/nvim/lazy/nvim-treesitter
test ! -e /Users/kyoneken/.local/share/nvim/lazy/nvim-treesitter-textobjects
test ! -e /Users/kyoneken/.local/share/nvim/tree-sitter-go-tmp
test -z "$(find /Users/kyoneken/.cache/nvim/luac -maxdepth 1 -type f -name '*nvim-treesitter*' -print -quit)"
```

Expected: exit status 0 and no output.

- [ ] **Step 2: Install the required CLI globally with mise**

```bash
mise use -g aqua:tree-sitter/tree-sitter@latest
```

Expected: mise records and installs a current tree-sitter CLI.

- [ ] **Step 3: Verify the CLI floor**

```bash
tree-sitter --version
```

Expected: version 0.26.1 or newer.

---

### Task 2: Replace the archived plugin configuration

**Files:**
- Modify: `lua/plugins/treesitter.lua`
- Modify: `lua/plugins/otter.lua`
- Modify: `lua/plugins/golang.lua`

**Interfaces:**
- Consumes: `vim.treesitter.start(bufnr, lang)`, `vim.treesitter.select(target)`, `require("nvim-treesitter").install(languages)`
- Produces: successor plugin spec, parser installation list, `NvimTreesitterStart` FileType autocmd, core incremental-selection mappings

- [ ] **Step 1: Record the expected pre-migration failures**

```bash
rg -n 'nvim-treesitter/nvim-treesitter|nvim-treesitter.configs|nvim-treesitter-textobjects|textobjects = true' lua/plugins
```

Expected: matches in `treesitter.lua`, `otter.lua`, and `golang.lua`; this proves the migration assertions can detect the old configuration.

- [ ] **Step 2: Replace `lua/plugins/treesitter.lua`**

Use this structure, preserving the existing `is-mise?` predicate:

```lua
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
```

- [ ] **Step 3: Update Otter's dependency**

In `lua/plugins/otter.lua`, replace:

```lua
"nvim-treesitter/nvim-treesitter"
```

with:

```lua
"neovim-treesitter/nvim-treesitter"
```

- [ ] **Step 4: Remove go.nvim's archived dependency and textobject setup**

Delete the `"nvim-treesitter/nvim-treesitter"` dependency from `lua/plugins/golang.lua` and change:

```lua
textobjects = true,
```

to:

```lua
textobjects = false,
```

- [ ] **Step 5: Run the configuration migration assertions**

```bash
if rg -n 'nvim-treesitter/nvim-treesitter|nvim-treesitter.configs|nvim-treesitter-textobjects|textobjects = true' lua/plugins; then exit 1; fi
rg -n 'neovim-treesitter/nvim-treesitter|treesitter-parser-registry|vim\.treesitter\.start|vim\.treesitter\.select|textobjects = false' lua/plugins
```

Expected: the negative search exits 0 because it finds nothing; the positive search finds the successor, core APIs, and disabled Go textobjects.

---

### Task 3: Refresh the lockfile from a clean successor installation

**Files:**
- Modify: `lazy-lock.json`
- Generated outside repository: isolated XDG data, state, and cache directories under `/tmp`

**Interfaces:**
- Consumes: the lazy.nvim specs from Task 2
- Produces: lock entries for the successor plugin and parser registry, with no textobjects entry

- [ ] **Step 1: Create isolated XDG directories**

```bash
treesitter_test_root="$(mktemp -d /tmp/nvim-treesitter-migration.XXXXXX)"
mkdir -p "$treesitter_test_root/data" "$treesitter_test_root/state" "$treesitter_test_root/cache"
```

- [ ] **Step 2: Install and synchronize plugins in the isolated environment**

```bash
XDG_CONFIG_HOME=/Volumes/T7/.ghq/github.com/kyoneken \
XDG_DATA_HOME="$treesitter_test_root/data" \
XDG_STATE_HOME="$treesitter_test_root/state" \
XDG_CACHE_HOME="$treesitter_test_root/cache" \
NVIM_APPNAME=nvim-config \
nvim --headless "+Lazy! sync" +qa
```

Expected: lazy.nvim clones `neovim-treesitter/nvim-treesitter` and `neovim-treesitter/treesitter-parser-registry` without cloning `nvim-treesitter-textobjects`.

- [ ] **Step 3: Update the repository lockfile using the normal configuration**

```bash
nvim --headless "+Lazy! sync" +qa
```

Expected: `lazy-lock.json` records the successor and registry revisions and removes `nvim-treesitter-textobjects`.

- [ ] **Step 4: Assert lockfile ownership and absence of the old textobjects package**

```bash
rg -n '"nvim-treesitter"|"treesitter-parser-registry"' lazy-lock.json
if rg -n 'nvim-treesitter-textobjects' lazy-lock.json; then exit 1; fi
```

Expected: successor and registry entries exist; textobjects does not.

---

### Task 4: Verify parsers, highlighting, and custom injections

**Files:**
- Verify: `after/queries/bash/injections.scm`
- Verify: `after/queries/python/injections.scm`
- Verify: `after/queries/toml/injections.scm`

**Interfaces:**
- Consumes: installed parsers and queries from Task 3
- Produces: runtime evidence that the migration supports Go, Python, TOML, Bash, highlighting, and mise injections

- [ ] **Step 1: Wait for or explicitly install the essential parsers**

```bash
nvim --headless "+lua require('nvim-treesitter').install({'go','python','toml','bash','kdl'}):wait(300000)" +qa
```

Expected: all five parser/query installations complete within five minutes.

- [ ] **Step 2: Verify parser loading**

```bash
nvim --headless "+lua for _, lang in ipairs({'go','python','toml','bash','kdl'}) do assert(vim.treesitter.language.add(lang), 'missing parser: '..lang) end" +qa
```

Expected: exit status 0.

- [ ] **Step 3: Verify custom queries compile**

```bash
nvim --headless "+lua for _, lang in ipairs({'bash','python','toml'}) do assert(vim.treesitter.query.get(lang, 'injections'), 'missing injections query: '..lang) end" +qa
```

Expected: exit status 0 with no query parse error.

- [ ] **Step 4: Verify core highlighting starts for bundled and external parsers**

```bash
nvim --headless \
  "+enew" \
  "+setfiletype lua" \
  "+lua assert(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()], 'Lua highlighter inactive')" \
  "+enew" \
  "+setfiletype go" \
  "+lua assert(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()], 'Go highlighter inactive')" \
  +qa
```

Expected: exit status 0.

- [ ] **Step 5: Run health checks and inspect output**

```bash
nvim --headless "+checkhealth vim.treesitter" "+checkhealth nvim-treesitter" "+silent write! /tmp/nvim-treesitter-health.txt" +qa
sed -n '1,260p' /tmp/nvim-treesitter-health.txt
```

Expected: no fatal parser ABI, missing CLI, or install-directory error.

---

### Task 5: Update documentation without overwriting user work

**Files:**
- Modify carefully: `README.md`
- Modify: `doc/README.md`
- Modify: `copilot-instructions.md`
- Preserve unchanged user edits: `doc/basic-usage.md`

**Interfaces:**
- Consumes: the final plugin names and operational commands
- Produces: documentation that distinguishes Neovim's core Tree-sitter support from the successor parser manager

- [ ] **Step 1: Save the user's current documentation diff for comparison**

```bash
git diff -- README.md doc/basic-usage.md > /tmp/nvim-treesitter-user-docs-before.patch
```

- [ ] **Step 2: Update Tree-sitter references**

Make these exact documentation changes:

- Raise the documented Neovim floor from 0.11 to 0.12.
- Describe Tree-sitter highlighting as a Neovim core feature.
- Link parser/query management to `https://github.com/neovim-treesitter/nvim-treesitter`.
- Keep the existing `tree-sitter` CLI installation instructions.
- Explain that `:TSInstall swift` is optional and provided by the successor manager.
- Remove claims that the archived plugin itself provides all highlighting behavior.

- [ ] **Step 3: Verify no stale archived link or old configuration API remains**

```bash
if rg -n 'github\.com/nvim-treesitter/nvim-treesitter|nvim-treesitter\.configs|nvim-treesitter-textobjects' README.md doc copilot-instructions.md lua; then exit 1; fi
rg -n 'github\.com/neovim-treesitter/nvim-treesitter|Neovim.*Tree-sitter|Tree-sitter.*Neovim' README.md doc copilot-instructions.md
```

Expected: no archived repository/API/textobjects references; successor and core descriptions are present.

- [ ] **Step 4: Confirm the user's pre-existing documentation additions remain**

```bash
rg -n '遅延読み込みが失敗する場合' README.md doc/basic-usage.md
git diff --check
```

Expected: both pre-existing troubleshooting sections remain and all diffs pass whitespace validation.

---

### Task 6: Final clean-state and runtime verification

**Files:**
- Verify: `lua/plugins/treesitter.lua`
- Verify: `lua/plugins/otter.lua`
- Verify: `lua/plugins/golang.lua`
- Verify: `lazy-lock.json`
- Verify: documentation files from Task 5

**Interfaces:**
- Consumes: all prior task outputs
- Produces: final evidence for cleanup, configuration integrity, and runtime behavior

- [ ] **Step 1: Confirm deleted old local assets have not returned**

```bash
test ! -e /Users/kyoneken/.local/share/nvim/lazy/nvim-treesitter-textobjects
test ! -e /Users/kyoneken/.local/share/nvim/tree-sitter-go-tmp
test -z "$(find /Users/kyoneken/.cache/nvim/luac -maxdepth 1 -type f -name '*nvim-treesitter-textobjects*' -print -quit)"
```

Expected: exit status 0. The `nvim-treesitter` directory may now exist only as the newly cloned successor; verify its remote in the next step.

- [ ] **Step 2: Verify the installed plugin remote is the successor**

```bash
git -C /Users/kyoneken/.local/share/nvim/lazy/nvim-treesitter remote get-url origin
```

Expected exactly:

```text
https://github.com/neovim-treesitter/nvim-treesitter.git
```

- [ ] **Step 3: Run the full headless smoke test**

```bash
nvim --headless "+lua assert(require('nvim-treesitter'))" "+lua assert(require('otter'))" +qa
```

Expected: exit status 0 with no Lua error.

- [ ] **Step 4: Review final repository state**

```bash
git diff --check
git status --short
git diff -- lua/plugins/treesitter.lua lua/plugins/otter.lua lua/plugins/golang.lua lazy-lock.json README.md doc/README.md copilot-instructions.md
```

Expected: only intended migration changes plus the user's preserved pre-existing README and basic-usage changes.
