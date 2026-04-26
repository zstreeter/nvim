return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		preset = "helix",
		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			presets = {
				operators = false,
				motions = false,
				text_objects = false,
				windows = false,
				nav = false,
				z = false,
				g = false,
			},
		},
		win = {
			border = "rounded",
			no_overlap = false,
			padding = { 0, 2 }, -- extra window padding [top/bottom, right/left]
			title = false,
			title_pos = "center",
			zindex = 1000,
		},
		show_help = false,
		show_keys = false,
		disable = {
			buftypes = {},
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- Group labels — lets which-key show a category title for each prefix.
		-- Direct (single-key) bindings get their description from the keymap callsite,
		-- so they don't need to be repeated here.
		wk.add({
			{ "<leader>a", group = "AI" },
			{ "<leader>b", group = "buffer" },
			{ "<leader>c", group = "code" },
			{ "<leader>d", group = "diagnostics" },
			{ "<leader>f", group = "find" },
			{ "<leader>g", group = "git" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>m", group = "mail" },
			{ "<leader>o", group = "obsidian" },
			{ "<leader>r", group = "rename/restart" },
			{ "<leader>s", group = "search/symbols" },
			{ "<leader>u", group = "ui/toggles" },
		})
	end,
}
