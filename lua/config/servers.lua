-- Shared LSP server list used by both lsp.lua and mason.lua
local M = {}

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
	"css_variables",
	"cssmodules_ls",
	"dockerls",
	"jsonls",
	"lemminx",
	"marksman",
	"nginx_language_server",
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
