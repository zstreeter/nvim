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

-- ── omarchy theme seam ──────────────────────────────────────────────────
check("theme: adapter returns a name or nil, and a colorscheme applied", function()
	local name = require("config.omarchy").get_colorscheme()
	assert(name == nil or type(name) == "string", "adapter returned " .. type(name))
	assert(vim.g.colors_name and #vim.g.colors_name > 0, "no colorscheme applied")
	-- adapter results must be real colorschemes — never the raw repo-ish name
	if name then
		assert(vim.tbl_contains(vim.fn.getcompletion("", "color"), name), name .. " is not an available colorscheme")
		-- applied scheme may flavour-expand (catppuccin-nvim → catppuccin-mocha);
		-- compare theme roots, not exact names
		local applied = vim.g.colors_name
		local root = function(s)
			return s:match("^[^-]+")
		end
		assert(root(applied) == root(name), ("omarchy says %s but %s is active"):format(name, applied))
	else
		assert(vim.startswith(vim.g.colors_name, "catppuccin"), "fallback should be catppuccin, got " .. vim.g.colors_name)
	end
end)

check("theme: lualine namespace shadow is gone and lualine boots", function()
	assert(vim.fn.isdirectory(vim.fn.stdpath("config") .. "/lua/lualine") == 0, "lua/lualine/ shadow dir exists")
	require("lazy").load({ plugins = { "lualine.nvim" } })
	assert(package.loaded["lualine"], "lualine did not load")
	-- the config no longer injects a theme into lualine's namespace
	local origin = vim.api.nvim_get_runtime_file("lua/lualine/themes/default.lua", true)
	for _, path in ipairs(origin) do
		assert(not path:find(vim.fn.stdpath("config"), 1, true), "config still shadows lualine.themes.default")
	end
end)

-- ── mail poller ─────────────────────────────────────────────────────────
local function envelopes_json(unseen, seen)
	local envs = {}
	for _ = 1, unseen do
		table.insert(envs, { flags = {} })
	end
	for _ = 1, seen do
		table.insert(envs, { flags = { { iana = "seen" } } })
	end
	return vim.json.encode({ envelopes = envs })
end

check("mail: notifies on unread increase, stop() halts polling", function()
	local mail = require("config.mail-notify")
	local sequence = { envelopes_json(1, 2), envelopes_json(3, 2), envelopes_json(3, 2) }
	local calls, notifications = 0, {}
	local orig_notify = vim.notify
	vim.notify = function(msg)
		table.insert(notifications, msg)
	end
	mail.start({
		accounts = { "testacct" },
		initial_delay_ms = 10,
		interval_ms = 40,
		runner = function(_, on_done)
			calls = calls + 1
			on_done(sequence[math.min(calls, #sequence)])
		end,
	})
	vim.wait(1000, function()
		return calls >= 2
	end)
	mail.stop()
	vim.notify = orig_notify
	assert(calls >= 2, "poller ticked " .. calls .. " times")
	local found
	for _, msg in ipairs(notifications) do
		if msg:find("new email") then
			found = msg
		end
	end
	assert(found, "no new-mail notification fired")
	assert(found:find("2 new emails in testacct", 1, true), "unexpected notification: " .. found)
	local settled = calls
	vim.wait(150)
	assert(calls == settled, "runner still polling after stop()")
end)

check("mail: schema drift warns loudly instead of reporting zero", function()
	local mail = require("config.mail-notify")
	local warned
	local orig_notify = vim.notify
	vim.notify = function(msg)
		if msg:find("schema") then
			warned = true
		end
	end
	mail.start({
		accounts = { "testacct" },
		initial_delay_ms = 10,
		interval_ms = 5000,
		runner = function(_, on_done)
			on_done('{"not_envelopes": []}')
		end,
	})
	vim.wait(1000, function()
		return warned
	end)
	mail.stop()
	vim.notify = orig_notify
	assert(warned, "schema drift was silent")
end)

-- ── herdr adapter ───────────────────────────────────────────────────────
check("herdr: pane list maps to sessions, non-agent panes ignored", function()
	require("lazy").load({ plugins = { "sidekick.nvim" } })
	local herdr = require("config.herdr")
	local sessions = herdr.sessions({
		{ pane_id = "w1:p1", cwd = "/tmp/a", workspace_id = "w1" }, -- plain shell
		{ pane_id = "w1:p3", cwd = "/tmp/b", foreground_cwd = "/tmp/c", agent = "pi", workspace_id = "w1" },
		{ pane_id = "w1:p4", cwd = "/tmp/d", agent = "not-a-sidekick-tool", workspace_id = "w1" },
	})
	assert(#sessions == 1, ("expected 1 session, got %d"):format(#sessions))
	assert(sessions[1].id == "herdr w1:p3", "session id is not keyed on the pane id")
	assert(sessions[1].herdr_pane_id == "w1:p3", "pane id not carried onto the session")
	assert(sessions[1].cwd == "/tmp/c", "foreground_cwd should win over the pane's start cwd")
	assert(sessions[1].tool.name == "pi", "agent label did not resolve to the sidekick tool")
end)

check("herdr: setup is a no-op outside a herdr pane", function()
	local Config = require("sidekick.config")
	local before = Config.cli.mux.backend
	local orig = vim.env.HERDR_ENV
	vim.env.HERDR_ENV = nil
	require("config.herdr").setup()
	vim.env.HERDR_ENV = orig
	assert(Config.cli.mux.backend == before, "backend was hijacked while outside herdr")
end)

-- ── result ──────────────────────────────────────────────────────────────
if #failures == 0 then
	print("SMOKE-PASS")
else
	print(("SMOKE-FAIL (%d)"):format(#failures))
end
