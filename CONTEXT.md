# Domain glossary

Terms with a specific meaning in this config. Architecture reviews and
refactors should use these names.

- **Icons module** (`lua/config/icons.lua`) — single source of truth for every
  glyph: LSP `kind` symbols and `diagnostics` severity signs. All four glyph
  consumers (blink/lspkind, navic breadcrumbs, diagnostic sign column, lualine)
  require it; hand-copied glyph tables are forbidden.
- **Smoke suite** (`tests/smoke.lua` via `tests/smoke.sh`) — headless boot +
  assertion suite; every structural refactor adds checks here and must pass
  before commit.
