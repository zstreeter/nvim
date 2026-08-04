-- Keymap registry: the single place that answers "what lives under a prefix".
-- which-key.lua consumes M.groups; plugin files own their handlers (lazy
-- `keys={}` specs stay in plugin files so lazy-loading keeps working).
--
-- Prefix ownership (where the handlers live):
--   <leader>a   ai/{copilot,opencode,pi,sidekick}.lua
--   <leader>b   snacks.lua (bufdelete)
--   <leader>c   lsp.lua (code action), snacks.lua (rename file)
--   <leader>d   lsp.lua (diagnostic jumps)
--   <leader>f   snacks.lua (pickers), lang/zotero-pdf.lua (<leader>fz)
--   <leader>g   snacks.lua (git pickers, lazygit)
--   <leader>l   lsp.lua (rename), lsp/{conform,nvim-lint}.lua (format/lint)
--   <leader>m   himalaya.lua
--   <leader>o   lang/obsidian.lua
--   <leader>q   bqf.lua (quickfix)
--   <leader>Q   lang/quarto.lua (also registers its own bindings via wk.add)
--   <leader>s   snacks.lua (symbols/grep)
--   <leader>u   snacks.lua (toggles)
--   m / <S-m>   harpoon.lua — deliberately shadows the built-in mark command
--
-- ponytail: groups-only registry; full binding centralization would fight
-- lazy.nvim's keys={} lazy-loading. Revisit if collisions keep appearing.
local M = {}

M.groups = {
	{ "<leader>a", group = "AI" },
	{ "<leader>b", group = "buffer" },
	{ "<leader>c", group = "code" },
	{ "<leader>d", group = "diagnostics" },
	{ "<leader>f", group = "find" },
	{ "<leader>g", group = "git" },
	{ "<leader>l", group = "LSP" },
	{ "<leader>m", group = "mail" },
	{ "<leader>o", group = "obsidian" },
	{ "<leader>s", group = "search/symbols" },
	{ "<leader>u", group = "ui/toggles" },
	{ "<leader>Q", group = "quarto", icon = "" },
	{ "<leader>Qm", group = "molten", icon = "" },
	{ "<leader>q", group = "quickfix" },
}

-- Collision detection at the interface: duplicate prefixes fail loudly at boot.
local seen = {}
for _, g in ipairs(M.groups) do
	if seen[g[1]] then
		error("config.keys: duplicate group prefix " .. g[1])
	end
	seen[g[1]] = true
end

return M
