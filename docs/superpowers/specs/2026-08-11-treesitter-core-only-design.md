# Tree-sitter Core-Only Design

## Goal

Remove the archived `nvim-treesitter` stack and all locally managed external
parsers, then retain only the Tree-sitter functionality shipped with Neovim
0.12. The clean local state takes priority over preserving external-language
Tree-sitter features.

## Scope

- Remove `nvim-treesitter`, `nvim-treesitter-textobjects`, the attempted
  successor fork, its parser registry, and Otter from the plugin graph.
- Remove custom Bash, Python, and TOML injection queries that depend on
  externally installed parsers.
- Remove Tree-sitter dependencies and textobject integration from `go.nvim`.
- Use Neovim core APIs only for bundled parsers.
- Remove obsolete Tree-sitter installation guidance from documentation.
- Report the reproduced successor installer timeout upstream without exposing
  personal filesystem paths.

The Go LSP, formatting, tests, debugging, snippets, and other non-Tree-sitter
development features remain unchanged.

## Runtime Design

Core Tree-sitter setup belongs in the existing core configuration rather than
in a lazy.nvim plugin spec. A `FileType` autocmd will enable highlighting only
for the explicit Neovim-bundled parser allowlist:

- `c`
- `lua`
- `markdown`
- `markdown_inline`
- `query`
- `vim`
- `vimdoc`

The callback will use `vim.treesitter.language.add()` as an availability guard
and `vim.treesitter.start()` to attach highlighting. It will not install,
download, compile, or discover external parsers.

Core syntax-node selection remains available through
`vim.treesitter.select("parent")` on `<C-space>` and
`vim.treesitter.select("child")` on visual-mode `<BS>`. Archived textobject
mappings (`af`, `if`, `ac`, `ic`) will not be restored.

No Tree-sitter indentation module will be configured.

## Removed Functionality

External Tree-sitter highlighting and queries for Go, Bash, Python, TOML, KDL,
Rust, JavaScript, TypeScript, and other non-bundled languages will no longer be
managed by this configuration. Those languages continue to use their normal
LSP and Vim syntax features where available.

Otter and the mise TOML embedded-language injections will be removed because
they require external TOML and injected-language parsers. Keeping dormant
configuration would make the clean state ambiguous.

The globally installed `tree-sitter` CLI is no longer a Neovim prerequisite.
It may be removed from mise if it was installed solely for this migration.

## Cleanup Contract

Before and after integration, verify absence of:

- `~/.local/share/nvim/lazy/nvim-treesitter`
- `~/.local/share/nvim/lazy/nvim-treesitter-textobjects`
- attempted successor and registry plugin directories
- parser build temporary directories
- `~/.cache/tree-sitter`
- compiled Lua cache entries containing `nvim-treesitter`
- task-specific Tree-sitter directories under `/tmp`

Cleanup must not remove Tree-sitter assets owned by Neovim itself, Copilot, or
unrelated plugins.

## Lockfile and Documentation

The lazy.nvim lockfile will contain no archived plugin, successor fork, parser
registry, textobjects, or Otter entries. Documentation will describe the
core-only behavior and its bundled-language limit. Instructions for
`:TSInstall`, `:TSUpdate`, or installing the Tree-sitter CLI for Neovim will be
removed.

Pre-existing user edits in `README.md` and `doc/basic-usage.md` must be merged
carefully and never overwritten.

## Verification

Static checks will reject references to the removed repositories, modules,
commands, and textobject configuration. A clean isolated Neovim run will verify
that no removed plugin is cloned and that the configuration starts without
errors.

Runtime checks will open a Lua buffer, confirm a core Tree-sitter highlighter
is active, and exercise the core syntax-selection mappings. Go configuration
checks will confirm Tree-sitter dependencies and textobjects are absent while
the remaining development setup is intact.

The final local-state audit will repeat the cleanup contract after all tests so
verification itself cannot leave Tree-sitter caches behind.

## Upstream Issue

Open an issue against `neovim-treesitter/nvim-treesitter` describing the
installer timeout observed during the abandoned successor attempt. Include:

- Neovim 0.12.4 and Tree-sitter CLI 0.26.12;
- a fresh, single-Go-parser reproduction with `max_jobs = 1`;
- successful direct `tree-sitter build` using the same checkout and cache;
- the plugin stopping after `Compiling parser...` with no installed artifact;
- the suspected `vim.system`/async completion boundary;
- confirmation that the 18-parser startup fan-out was eliminated from the
  minimal reproduction.

Use placeholders for home and temporary paths. Do not attach unrelated logs or
configuration.
