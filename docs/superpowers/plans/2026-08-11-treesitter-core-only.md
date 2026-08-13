# Tree-sitter Core-Only Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove all external Tree-sitter management and retain only Neovim 0.12's bundled parsers, highlighting, and syntax-node selection.

**Architecture:** Core configuration owns a fixed bundled-parser allowlist and starts highlighting through `vim.treesitter` APIs. lazy.nvim contains no Tree-sitter manager, textobjects, registry, or Otter plugin; Go keeps only its non-Tree-sitter development features.

**Tech Stack:** Neovim 0.12.4, Lua, lazy.nvim, GitHub CLI

## Global Constraints

- The clean local state takes priority over preserving external-language Tree-sitter features.
- Use only the bundled parsers `c`, `lua`, `markdown`, `markdown_inline`, `query`, `vim`, and `vimdoc`.
- Do not install, download, compile, or discover external Tree-sitter parsers.
- Do not restore `nvim-treesitter-textobjects` or the `af`, `if`, `ac`, and `ic` mappings.
- Do not configure Tree-sitter indentation.
- Preserve Go LSP, formatting, tests, debugging, snippets, and other non-Tree-sitter features.
- Remove Otter and the custom Bash, Python, and TOML injection queries.
- Preserve the user's pre-existing uncommitted changes in `README.md` and `doc/basic-usage.md`.
- Do not delete Tree-sitter assets owned by Neovim itself, Copilot, or unrelated plugins.
- The upstream issue must replace personal home and temporary paths with neutral placeholders.

---

### Task 1: Remove migration-only CLI and re-establish a clean local state

**Files:**
- Modify externally: `/Users/kyoneken/.config/mise/config.toml` through `mise unuse -g`
- Verify externally: `/Users/kyoneken/.local/share/nvim/`
- Verify externally: `/Users/kyoneken/.cache/nvim/`
- Verify externally: `/Users/kyoneken/.cache/tree-sitter/`

**Interfaces:**
- Consumes: the cleanup contract in the core-only design
- Produces: no migration-installed Tree-sitter CLI and no old or attempted plugin cache

- [ ] **Step 1: Verify the CLI was added by the abandoned migration**

```bash
rg -n '^"aqua:tree-sitter/tree-sitter" = "latest"$' /Users/kyoneken/.config/mise/config.toml
```

Expected: exactly one match.

- [ ] **Step 2: Remove the migration-only CLI from global mise configuration**

```bash
mise unuse -g 'aqua:tree-sitter/tree-sitter@latest' --yes
```

Expected: the global config entry and its now-unused installation are removed. Keep the general mise shim PATH line in `/Users/kyoneken/.zprofile`; other global mise tools use it.

- [ ] **Step 3: Remove only the known Tree-sitter migration artifacts**

Resolve each exact path first, then remove it if present:

```text
/Users/kyoneken/.local/share/nvim/lazy/nvim-treesitter
/Users/kyoneken/.local/share/nvim/lazy/nvim-treesitter-textobjects
/Users/kyoneken/.local/share/nvim/lazy/treesitter-parser-registry
/Users/kyoneken/.local/share/nvim/tree-sitter-go-tmp
/Users/kyoneken/.cache/tree-sitter
```

Also remove only files directly under `/Users/kyoneken/.cache/nvim/luac` whose names contain `nvim-treesitter`.

- [ ] **Step 4: Verify the cleanup contract**

```bash
for path in \
  /Users/kyoneken/.local/share/nvim/lazy/nvim-treesitter \
  /Users/kyoneken/.local/share/nvim/lazy/nvim-treesitter-textobjects \
  /Users/kyoneken/.local/share/nvim/lazy/treesitter-parser-registry \
  /Users/kyoneken/.local/share/nvim/tree-sitter-go-tmp \
  /Users/kyoneken/.cache/tree-sitter; do
  test ! -e "$path" || exit 1
done
test -z "$(find /Users/kyoneken/.cache/nvim/luac -maxdepth 1 -type f -name '*nvim-treesitter*' -print -quit 2>/dev/null)"
! rg -n '^"aqua:tree-sitter/tree-sitter"' /Users/kyoneken/.config/mise/config.toml
```

Expected: exit status 0 and no output. Do not commit external configuration.

---

### Task 2: Replace plugin-owned behavior with Neovim core behavior

**Files:**
- Modify: `lua/config/autocmds.lua`
- Modify: `lua/config/keymaps.lua`
- Modify: `lua/plugins/golang.lua`
- Delete: `lua/plugins/treesitter.lua`
- Delete: `lua/plugins/otter.lua`
- Delete: `after/queries/bash/injections.scm`
- Delete: `after/queries/python/injections.scm`
- Delete: `after/queries/toml/injections.scm`

**Interfaces:**
- Consumes: `vim.treesitter.language.get_lang(filetype)`, `vim.treesitter.language.add(lang)`, `vim.treesitter.start(bufnr, lang)`, `vim.treesitter.select(direction)`
- Produces: `NvimCoreTreesitter` FileType autocmd and core selection mappings

- [ ] **Step 1: Run the desired-state assertions and verify RED**

```bash
test ! -e lua/plugins/treesitter.lua
test ! -e lua/plugins/otter.lua
test ! -d after/queries
if rg -n 'nvim-treesitter|neovim-treesitter|treesitter-parser-registry|otter.nvim|textobjects = true' lua after; then exit 1; fi
rg -n 'NvimCoreTreesitter|vim\.treesitter\.start|vim\.treesitter\.select' lua/config
```

Expected: failure because the plugin files and injection queries still exist and the core configuration does not.

- [ ] **Step 2: Add bundled-parser highlighting to `lua/config/autocmds.lua`**

Append this exact configuration:

```lua
local bundled_treesitter_parsers = {
  c = true,
  lua = true,
  markdown = true,
  markdown_inline = true,
  query = true,
  vim = true,
  vimdoc = true,
}

autocmd("FileType", {
  group = augroup("NvimCoreTreesitter", { clear = true }),
  callback = function(event)
    local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
    if lang and bundled_treesitter_parsers[lang] and vim.treesitter.language.add(lang) then
      vim.treesitter.start(event.buf, lang)
    end
  end,
})
```

- [ ] **Step 3: Add core syntax-node selection to `lua/config/keymaps.lua`**

Append:

```lua
keymap.set({ "n", "x" }, "<C-space>", function()
  vim.treesitter.select("parent")
end, { desc = "構文ノードを拡張選択" })

keymap.set("x", "<BS>", function()
  vim.treesitter.select("child")
end, { desc = "構文ノードの選択を縮小" })
```

- [ ] **Step 4: Delete plugin-owned Tree-sitter and injection configuration**

Delete the two plugin files and the three query files listed above. Remove the empty `after/queries/{bash,python,toml}` directories if the filesystem leaves them behind.

- [ ] **Step 5: Keep Go without Tree-sitter integration**

In `lua/plugins/golang.lua`, ensure the dependencies contain no Tree-sitter repository and use:

```lua
textobjects = false,
```

Do not alter the Go LSP, formatting, tests, DAP, snippets, commands, or build step.

- [ ] **Step 6: Run the desired-state assertions and verify GREEN**

Run the Step 1 command again.

Expected: exit status 0; the negative search is empty and the positive search finds the core autocmd and mappings.

- [ ] **Step 7: Verify Lua syntax and commit**

```bash
nvim -u NONE -i NONE --headless \
  "+lua assert(loadfile('lua/config/autocmds.lua'))" \
  "+lua assert(loadfile('lua/config/keymaps.lua'))" \
  "+lua assert(loadfile('lua/plugins/golang.lua'))" \
  +qa
git diff --check
git add lua/config/autocmds.lua lua/config/keymaps.lua lua/plugins/golang.lua lua/plugins/treesitter.lua lua/plugins/otter.lua after/queries
git commit -m "refactor: use Neovim core Tree-sitter"
```

---

### Task 3: Remove Tree-sitter plugins from the lockfile

**Files:**
- Modify: `lazy-lock.json`
- Generated outside repository: a new isolated XDG root under `/tmp`

**Interfaces:**
- Consumes: the core-only lazy.nvim plugin graph from Task 2
- Produces: a lockfile without archived, successor, registry, textobjects, or Otter entries

- [ ] **Step 1: Verify the lockfile assertion is RED**

```bash
rg -n 'nvim-treesitter|treesitter-parser-registry|otter.nvim' lazy-lock.json
```

Expected: at least the successor and registry entries are found.

- [ ] **Step 2: Create a fresh isolated XDG root and synchronize lazy.nvim**

```bash
core_test_root="$(mktemp -d /tmp/nvim-treesitter-core-only.XXXXXX)"
mkdir -p "$core_test_root/config/core-only" "$core_test_root/data" "$core_test_root/state" "$core_test_root/cache"
ln -s "$PWD" "$core_test_root/config/core-only-config"
XDG_CONFIG_HOME="$core_test_root/config" \
XDG_DATA_HOME="$core_test_root/data" \
XDG_STATE_HOME="$core_test_root/state" \
XDG_CACHE_HOME="$core_test_root/cache" \
NVIM_APPNAME=core-only-config \
nvim --headless "+Lazy! sync" +qa
```

If the app-name symlink layout does not resolve `init.lua`, replace it with an equivalent symlink whose exact target remains this worktree. Do not point the isolated run at the main checkout.

- [ ] **Step 3: Assert removed plugins were not cloned**

```bash
test ! -e "$core_test_root/data/core-only-config/lazy/nvim-treesitter"
test ! -e "$core_test_root/data/core-only-config/lazy/nvim-treesitter-textobjects"
test ! -e "$core_test_root/data/core-only-config/lazy/treesitter-parser-registry"
test ! -e "$core_test_root/data/core-only-config/lazy/otter.nvim"
```

Expected: exit status 0.

- [ ] **Step 4: Refresh and assert the repository lockfile**

Use the isolated configuration to generate the lockfile, then run:

```bash
if rg -n 'nvim-treesitter|treesitter-parser-registry|otter.nvim' lazy-lock.json; then exit 1; fi
git diff --check
git add -f lazy-lock.json
git commit -m "chore: remove Tree-sitter plugins from lockfile"
```

Expected: no removed plugin entry remains.

---

### Task 4: Update documentation for core-only behavior

**Files:**
- Modify carefully: `README.md`
- Modify: `doc/README.md`
- Verify without overwriting: `doc/basic-usage.md`

**Interfaces:**
- Consumes: the bundled-parser allowlist and removed-feature list from Task 2
- Produces: user documentation with no external parser installation instructions

- [ ] **Step 1: Record documentation assertions in their RED state**

```bash
rg -n 'nvim-treesitter|TSInstall|TSUpdate|tree-sitter/tree-sitter|brew install tree-sitter|Otter|otter.nvim' README.md doc/README.md doc/basic-usage.md
```

Expected: old installation and plugin documentation is found.

- [ ] **Step 2: Update `README.md`**

Remove Tree-sitter from package-manager prerequisites, Swift parser installation guidance, `:TSInstall` troubleshooting, and the archived plugin link. Describe that Neovim's bundled parsers provide Tree-sitter highlighting only for C, Lua, Markdown, Query, Vim, and Vim help; external languages fall back to LSP and normal syntax support.

Work from the file currently in the main checkout when integrating so the user's uncommitted edits remain byte-for-byte except for the Tree-sitter-specific hunks.

- [ ] **Step 3: Update `doc/README.md`**

Remove `nvim-treesitter` from the plugin list and describe the core configuration in `lua/config/autocmds.lua` and `lua/config/keymaps.lua`. Remove `lua/plugins/treesitter.lua` and `lua/plugins/otter.lua` from structure examples if present.

- [ ] **Step 4: Verify documentation and commit**

```bash
if rg -n 'nvim-treesitter|TSInstall|TSUpdate|tree-sitter/tree-sitter|brew install tree-sitter|Otter|otter.nvim' README.md doc/README.md doc/basic-usage.md; then exit 1; fi
rg -n 'Neovim.*Tree-sitter|同梱パーサー|lua/config/autocmds.lua|lua/config/keymaps.lua' README.md doc/README.md
git diff --check
git add README.md doc/README.md
git commit -m "docs: document core-only Tree-sitter support"
```

Do not stage `doc/basic-usage.md` unless a Tree-sitter-specific edit is necessary. Preserve all unrelated user changes.

---

### Task 5: Report the successor installer timeout upstream

**Files:**
- Create outside repository: issue body in the task report workspace
- Modify externally: GitHub issue tracker for `neovim-treesitter/nvim-treesitter`

**Interfaces:**
- Consumes: `.superpowers/sdd/2026-08-11-treesitter-migration/task-4-report.md`
- Produces: one public GitHub issue URL or a documented duplicate URL

- [ ] **Step 1: Search open and closed issues for a duplicate**

```bash
gh issue list --repo neovim-treesitter/nvim-treesitter --state all --limit 100 --search 'Compiling parser timeout vim.system async'
```

Expected: inspect results before creating anything. If a matching issue exists, add only genuinely new reproduction evidence as a comment and record that URL instead of opening a duplicate.

- [ ] **Step 2: Prepare a sanitized issue body**

The body must include:

```text
Neovim: 0.12.4
tree-sitter CLI: 0.26.12
parser: go
max_jobs: 1
```

State that a fresh `-u NONE` environment downloaded the parser and query repositories but stopped after `Compiling parser...`; direct `tree-sitter build` on the same checkout completed successfully; no parser artifact was installed; and the reproduction does not load the normal 18-parser configuration. Replace `/Users/kyoneken/...` with `$HOME/...` and random `/tmp` names with `$TMPDIR/<test-root>`.

- [ ] **Step 3: Create the issue or comment on the duplicate**

Use `gh issue create --repo neovim-treesitter/nvim-treesitter` with a concise title and the sanitized body file, or `gh issue comment` for a confirmed duplicate. Do not include unrelated configuration, access tokens, or full environment dumps.

- [ ] **Step 4: Verify the published content**

```bash
gh issue view --repo neovim-treesitter/nvim-treesitter <issue-number> --json url,title,body
```

Expected: version data and minimal reproduction are present; personal absolute paths are absent. Record the URL in the task report. No repository commit is required.

---

### Task 6: Verify core-only runtime and repeat final cleanup

**Files:**
- Verify: `lua/config/autocmds.lua`
- Verify: `lua/config/keymaps.lua`
- Verify: `lua/plugins/golang.lua`
- Verify: `lazy-lock.json`
- Generated outside repository: isolated XDG root under `/tmp`

**Interfaces:**
- Consumes: Tasks 1-4
- Produces: runtime and local-cleanliness acceptance evidence

- [ ] **Step 1: Confirm the bundled parser inventory from Neovim itself**

```bash
nvim -u NONE -i NONE --headless \
  "+lua local expected={c=true,lua=true,markdown=true,markdown_inline=true,query=true,vim=true,vimdoc=true}; for _,p in ipairs(vim.api.nvim_get_runtime_file('parser/*',true)) do local lang=vim.fs.basename(p):gsub('%..+$',''); assert(expected[lang], 'unexpected bundled parser: '..lang); expected[lang]=nil end; assert(vim.tbl_isempty(expected), 'missing bundled parser')" \
  +qa
```

Expected: exit status 0.

- [ ] **Step 2: Verify core highlighting in the isolated app**

Using the Task 3 XDG root:

```bash
XDG_CONFIG_HOME="$core_test_root/config" \
XDG_DATA_HOME="$core_test_root/data" \
XDG_STATE_HOME="$core_test_root/state" \
XDG_CACHE_HOME="$core_test_root/cache" \
NVIM_APPNAME=core-only-config \
nvim --headless \
  "+enew" \
  "+setfiletype lua" \
  "+lua assert(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()], 'Lua core highlighter inactive')" \
  +qa
```

Expected: exit status 0 without installing a parser.

- [ ] **Step 3: Verify mappings and removed integrations**

```bash
XDG_CONFIG_HOME="$core_test_root/config" \
XDG_DATA_HOME="$core_test_root/data" \
XDG_STATE_HOME="$core_test_root/state" \
XDG_CACHE_HOME="$core_test_root/cache" \
NVIM_APPNAME=core-only-config \
nvim --headless \
  "+lua assert(vim.fn.maparg('<C-space>', 'n') ~= '', 'missing parent selection mapping')" \
  "+lua assert(vim.fn.maparg('<BS>', 'x') ~= '', 'missing child selection mapping')" \
  +qa
if rg -n 'nvim-treesitter|neovim-treesitter|treesitter-parser-registry|otter.nvim|textobjects = true|TSInstall|TSUpdate' lua after README.md doc/README.md doc/basic-usage.md lazy-lock.json; then exit 1; fi
```

Expected: mappings exist and the negative search is empty.

- [ ] **Step 4: Inspect health output**

```bash
XDG_CONFIG_HOME="$core_test_root/config" \
XDG_DATA_HOME="$core_test_root/data" \
XDG_STATE_HOME="$core_test_root/state" \
XDG_CACHE_HOME="$core_test_root/cache" \
NVIM_APPNAME=core-only-config \
nvim --headless "+checkhealth vim.treesitter" "+silent write! $core_test_root/health.txt" +qa
sed -n '1,220p' "$core_test_root/health.txt"
```

Expected: no fatal bundled-parser ABI or query error.

- [ ] **Step 5: Delete the exact isolated test root and repeat the cleanup audit**

Delete only the resolved `core_test_root`, then repeat Task 1 Step 4. Also assert no `/tmp/nvim-treesitter-core-only.*` directory remains.

- [ ] **Step 6: Verify branch state**

```bash
git diff --check
git status --short
git log --oneline --decorate -10
```

Expected: tracked work is committed, coordination reports remain ignored, and the implementation branch contains the core-only commits ready for final review and integration.
