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

-- ── keymap registry ─────────────────────────────────────────────────────
check("keys: registry loads, has groups, rejects duplicates", function()
	local keys = require("config.keys")
	assert(#keys.groups >= 14, "expected >=14 group entries, got " .. #keys.groups)
	local prefixes = {}
	for _, g in ipairs(keys.groups) do
		assert(not prefixes[g[1]], "duplicate prefix " .. g[1])
		prefixes[g[1]] = true
	end
	assert(prefixes["<leader>q"] and prefixes["<leader>Q"], "quickfix/quarto groups missing")
	assert(not prefixes["<leader>r"], "phantom rename/restart group is back")
end)

check("keys: which-key consumes the registry", function()
	require("lazy").load({ plugins = { "which-key.nvim" } })
	assert(package.loaded["config.keys"], "which-key did not require config.keys")
end)

check("keys: timeoutlen is 300 and stated in options.lua", function()
	assert(vim.o.timeoutlen == 300, "timeoutlen is " .. vim.o.timeoutlen)
end)

check("keys: <leader>/ is the built-in gc toggle", function()
	local rhs
	for _, m in ipairs(vim.api.nvim_get_keymap("n")) do
		if m.lhs == " /" then
			rhs = m.rhs
		end
	end
	assert(rhs == "gcc", "<leader>/ rhs is " .. tostring(rhs) .. ", expected gcc")
	assert(package.loaded["Comment"] == nil, "Comment.nvim loaded — should be deleted")
end)

check("keys: built-in gt (next tab) is not shadowed", function()
	assert(vim.fn.maparg("gt", "n") == "", "gt is mapped: " .. vim.fn.maparg("gt", "n"))
end)

check("keys: <C-j>/<C-k> owned by neoscroll alone", function()
	local cj = vim.fn.maparg("<C-j>", "n")
	assert(cj:find("scroll") or cj:find("neoscroll"), "<C-j> not a neoscroll map: " .. cj)
	assert(cj ~= "<C-D>", "raw <C-D> nnoremap is back")
end)

-- ── result ──────────────────────────────────────────────────────────────
if #failures == 0 then
	print("SMOKE-PASS")
else
	print(("SMOKE-FAIL (%d)"):format(#failures))
end
