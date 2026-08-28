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
- **Keymap registry** (`lua/config/keys.lua`) — single source for which-key
  group labels and prefix ownership; errors at boot on duplicate prefixes.
  Plugin handlers stay in plugin files (lazy `keys={}` keeps lazy-loading);
  full binding centralization was deliberately not done.
- **Omarchy theme adapter** (`lua/config/omarchy.lua`) — the only code that
  knows omarchy hands us a LazyVim-shaped spec via the
  `lua/plugins/theme.lua` symlink. Interface:
  `get_colorscheme() → string|nil` (validated against available colorschemes,
  repo-ish names normalized). `colorscheme.lua` consumes it; catppuccin is
  the non-omarchy fallback.
- **Mail notify module** (`lua/config/mail-notify.lua`) — background new-mail
  polling with an explicit lifecycle: `start(opts)` / `stop()`, started
  eagerly from init.lua, stopped on VimLeavePre. The job runner is
  injectable; JSON parsing and per-account unread state are private.
  Distinct from the himalaya plugin spec, which owns only `<leader>m`
  keymaps and lazy-loads on first use.
- **Smoke suite** (`tests/smoke.lua` via `tests/smoke.sh`) — headless boot +
  assertion suite; every structural refactor adds checks here and must pass
  before commit.
