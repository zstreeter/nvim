# Domain glossary

Terms with a specific meaning in this config. Architecture reviews and
refactors should use these names.

- **Icons module** (`lua/config/icons.lua`) — single source of truth for every
  glyph: LSP `kind` symbols and `diagnostics` severity signs. All four glyph
  consumers (blink/lspkind, navic breadcrumbs, diagnostic sign column, lualine)
  require it; hand-copied glyph tables are forbidden.
- **LSP module** — `lua/config/lsp.lua` owns the seam: capabilities (computed
  once, blink-extended), diagnostics display, LspAttach keymaps, and
  `vim.lsp.enable()` over the server list. `lua/config/servers.lua` is its
  data interface (server + tool names). `lsp/*.lua` are adapters: pure
  settings tables, no `require`s. nvim-lspconfig is a data source only —
  its bundled `lsp/` dir resolves servers with no local adapter.
- **Smoke suite** (`tests/smoke.lua` via `tests/smoke.sh`) — headless boot +
  assertion suite; every structural refactor adds checks here and must pass
  before commit.
