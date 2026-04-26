return {
	"jalvesaq/zotcite",
	ft = { "markdown", "quarto", "rmd", "pandoc", "tex", "typst" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("zotcite").setup({
			SQL_path = vim.fn.expand("~/Zotero/zotero.sqlite"),
			tmpdir = vim.fn.stdpath("cache") .. "/zotcite",
			hl_cite_key = true,
			conceallevel = 2,
			wait_attachment = false,
			open_in_zotero = false,
		})
	end,
}
