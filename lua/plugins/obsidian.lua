return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = { "markdown", "quarto" },
	event = {
		"BufReadPre " .. vim.fn.expand("~") .. "/research/**.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/research/**.md",
		"BufReadPre " .. vim.fn.expand("~") .. "/research/**.qmd",
		"BufNewFile " .. vim.fn.expand("~") .. "/research/**.qmd",
	},
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		workspaces = {
			{
				name = "research",
				path = "~/research",
			},
		},
		notes_subdir = "notes",
		new_notes_location = "notes_subdir",
		-- zotcite handles @citekey completion against zotero.sqlite
		completion = { nvim_cmp = false, blink = false, min_chars = 2 },
		picker = { name = "snacks.pick" },
		-- markview handles in-buffer rendering
		ui = { enable = false },
		attachments = { img_folder = "assets" },
	},
	keys = {
		{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: New note" },
		{ "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: Quick switch" },
		{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Obsidian: Backlinks" },
		{ "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Obsidian: Tags" },
		{ "<leader>og", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: Grep" },
		{ "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Obsidian: Follow link" },
		{ "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Obsidian: Switch workspace" },
	},
}
