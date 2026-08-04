-- nvim-lspconfig is used purely as a DATA SOURCE: its bundled lsp/ directory
-- provides configs for every server in config/servers.lua that has no local
-- override in this repo's lsp/ directory (11 of 15 at last count).
-- No setup() call exists or is needed — vim.lsp.enable() (config/lsp.lua)
-- resolves configs from the runtimepath at FileType time.
-- Loaded eagerly so its lsp/ dir is on the rtp before any buffer opens.
return {
	"neovim/nvim-lspconfig",
	lazy = false,
}
