return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Oil",
	keys = {
		{ "-", "<cmd>Oil --float<cr>", desc = "Open parent directory" },
	},
	opts = {
		default_file_explorer = false,
		float = {
			max_height = 20,
			max_width = 60,
		},
		view_options = {
			show_hidden = true,
		},
	},
}
