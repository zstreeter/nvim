# nvim

Personal Neovim config. Lazy.nvim + Lua, modular layout under `lua/`.
Originally seeded from [Launch.nvim](https://github.com/LunarVim/Launch.nvim);
diverged substantially since.

## Install

```sh
git clone <this-repo> ~/.config/nvim
nvim   # lazy.nvim bootstraps and installs plugins on first run
```

External tools the config relies on (install via your package manager):
`ripgrep`, `fd`, `node` (Copilot), and the AI CLIs you actually use
(`claude`, `opencode`, `pi`).

## Layout

```
init.lua                      # entry point — loads config/* in order
lua/config/
  options.lua                 # vim.opt — tabs, search, UI
  keymaps.lua                 # global keymaps + leader setup
  autocommands.lua            # autocmds (yank highlight, trim, etc.)
  lazy.lua                    # lazy.nvim bootstrap + spec imports
  colorscheme.lua             # picks omarchy theme or catppuccin
  lsp.lua                     # vim.lsp.config + LspAttach keymaps
  servers.lua                 # shared LSP server / formatter list
lua/plugins/                  # plugin specs — auto-imported by lazy
  ai/                         # copilot, sidekick, opencode, pi
  lsp/                        # mason, lspconfig, conform, nvim-lint, lazydev
  lang/                       # per-language plugins (unreal, latex, obsidian…)
  ui/                         # theme, transparent, lualine, …
  *.lua                       # editor mechanics (snacks, which-key, oil…)
```

Add a new plugin: drop a `<name>.lua` file into the right subdir. Lazy
auto-imports it. Each spec returns a single table.

## Discovering keymaps

- `<leader>?` — fuzzy-search every keymap
- Press `<leader>` and wait — which-key shows the submenu
- `:checkhealth` to verify plugins, LSPs, formatters

## Leader cheatsheet

`<leader>` is `<Space>`. Localleader is `\`.

| Group          | Prefix       | Notable chords                                            |
|----------------|--------------|-----------------------------------------------------------|
| AI             | `<leader>a`  | `as` Sidekick · `ao` OpenCode · `ap` Pi                   |
| Buffer         | `<leader>b`  | `bd` delete                                               |
| Code (LSP)     | `<leader>c`  | `ca` code action · `cR` rename file                       |
| Diagnostics    | `<leader>d`  | `dj` / `dk` next/prev                                     |
| Find           | `<leader>f`  | `ff` files · `fg` git files · `fk` keymaps · …            |
| Git            | `<leader>g`  | `gg` lazygit · `gs` status · `gd` diff · `gB` browse      |
| LSP            | `<leader>l`  | `lf` format · `lr` rename                                 |
| Mail           | `<leader>m`  | (himalaya)                                                |
| Obsidian       | `<leader>o`  | `oo` switch · `on` new · `og` grep                        |
| Rename/restart | `<leader>r`  |                                                           |
| Search/symbols | `<leader>s`  | `ss` LSP symbols · `sg` grep                              |
| UI/toggles     | `<leader>u`  | `uz` zen · `uw` wrap · `ud` diagnostics · `uC` colorscheme |

Single direct chords: `<leader><space>` smart-find · `<leader>,` buffers ·
`<leader>:` cmd history · `<leader>.` scratch · `<leader>e` file tree ·
`<leader>n` notifications · `<leader>w` save · `<leader>?` keymap search.

LSP nav (no leader): `gd` def · `gD` decl · `gr` refs · `gI` impl · `gy` type · `K` hover · `gl` line diagnostics.

## Conventions

- Plugin specs prefer declarative `opts = {...}` over `config = function()`. Use `config` only when you need work *after* setup (post-setup keymaps, custom autocmds, etc.).
- Keymaps go in the spec's `keys = {...}` block so lazy.nvim can use them as load triggers.
- Group labels for which-key live in `lua/plugins/which-key.lua`.
- `stylua.toml` at the repo root drives formatting. Save runs conform's `format_on_save`.

## License

Personal config. No license; do whatever.
