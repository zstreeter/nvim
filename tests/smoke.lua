-- Headless smoke tests. Run via tests/smoke.sh (or:
--   nvim --headless "+lua dofile('tests/smoke.lua')" +qa )
-- Each phase of the architecture work adds checks here; all must pass.

local failures = {}
local function check(name, fn)
	local ok, err = pcall(fn)
	if ok then
		print("ok   " .. name)
	else
		table.insert(failures, name .. ": " .. tostring(err))
		print("FAIL " .. name .. ": " .. tostring(err))
	end
end

-- ── icons module ────────────────────────────────────────────────────────
check("icons: module shape", function()
	local i = require("config.icons")
	assert(type(i.kind) == "table", "kind missing")
	assert(i.kind.Function and i.kind.Variable and i.kind.Module, "kind entries missing")
	assert(i.diagnostics.Error and i.diagnostics.Warn and i.diagnostics.Hint and i.diagnostics.Info)
end)

check("icons: diagnostic signs use the shared table", function()
	local i = require("config.icons")
	local signs = vim.diagnostic.config().signs
	assert(type(signs) == "table" and type(signs.text) == "table", "signs.text not configured")
	assert(signs.text[vim.diagnostic.severity.ERROR] == i.diagnostics.Error, "sign column drifted from icons module")
end)

check("icons: blink/lspkind boots against the shared table", function()
	require("lazy").load({ plugins = { "blink.cmp" } })
	local lspkind = require("lspkind")
	local sym = lspkind.symbolic("Function", { mode = "symbol" })
	assert(type(sym) == "string" and #sym > 0, "lspkind returned no symbol")
end)

check("icons: breadcrumbs/navic boots against the shared table", function()
	require("lazy").load({ plugins = { "breadcrumbs.nvim" } })
	assert(package.loaded["nvim-navic"], "navic did not load")
end)

-- ── LSP module ──────────────────────────────────────────────────────────
check("lsp: every enabled server resolves a config", function()
	local servers = require("config.servers")
	for _, name in ipairs(servers.lsp_servers) do
		local cfg = vim.lsp.config[name]
		assert(type(cfg) == "table", name .. " has no resolvable config")
		assert(cfg.cmd, name .. " config has no cmd")
	end
end)

check("lsp: blink capabilities applied via the '*' default", function()
	local cfg = vim.lsp.config.ts_ls
	local snip = vim.tbl_get(cfg, "capabilities", "textDocument", "completion", "completionItem", "snippetSupport")
	assert(snip == true, "blink capabilities not merged into resolved server config")
end)

-- ── result ──────────────────────────────────────────────────────────────
if #failures == 0 then
	print("SMOKE-PASS")
else
	print(("SMOKE-FAIL (%d)"):format(#failures))
end
