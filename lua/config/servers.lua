-- Shared LSP server list used by both lsp.lua and mason.lua
local M = {}

-- Add back if needed: css_variables, cssmodules_ls, lemminx (XML), nginx_language_server.
M.lsp_servers = {
	"ts_ls",
	"lua_ls",
	"tailwindcss",
	"eslint",
	"rust_analyzer",
	"gopls",
	"html",
	"cssls",
	"basedpyright",
	"bashls",
	"dockerls",
	"jsonls",
	"marksman",
	"taplo",
	"yamlls",
}

M.formatters_and_linters = {
	"prettier",
	"stylua",
	"black",
	"isort",
	"pylint",
	"shellcheck",
	"shfmt",
}

return M
