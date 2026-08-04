-- Enable LSP servers (list defined in config/servers.lua)
local servers = require("config.servers")
local icons = require("config.icons")
vim.lsp.enable(servers.lsp_servers)

-- Configure diagnostic display with custom signs
vim.diagnostic.config({
	float = {
		focusable = true,
		style = "minimal",
		border = "rounded",
		source = true, -- Show source in diagnostic popup window
		header = "",
		prefix = "",
	},
	virtual_text = false,
	virtual_lines = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- Enable inlay hints
vim.lsp.inlay_hint.enable(false)

-- Default capabilities for every server, extended by blink.cmp when present.
-- This is the ONLY place capabilities are computed; lsp/*.lua stay pure data.
local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok then
	capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
else
	vim.notify("blink.cmp not available — LSP completion capabilities degraded", vim.log.levels.WARN)
end
vim.lsp.config("*", {
	capabilities = capabilities,
})

local keymap = vim.keymap
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf, silent = true }

		-- Goto/reference pickers (gd/gD/gr/gI/gy) are global maps owned by
		-- snacks.lua — not duplicated here. Buffer-local rebinds used to
		-- shadow built-in gt (next tab) and diverge on gi/gI, gt/gy.

		opts.desc = "See available code actions"
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

		opts.desc = "Smart rename"
		keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)

		opts.desc = "Show line diagnostics"
		keymap.set("n", "gl", vim.diagnostic.open_float, opts)

		opts.desc = "Go to previous diagnostic"
		keymap.set("n", "<leader>dk", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opts)

		opts.desc = "Go to next diagnostic"
		keymap.set("n", "<leader>dj", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opts)

		opts.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts)
	end,
})
