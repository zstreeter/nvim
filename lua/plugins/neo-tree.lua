return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
	},
	init = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
	end,
	opts = {
		close_if_last_window = false,
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		source_selector = {
			sources = {
				{ source = "filesystem", display_name = " 󰉓 Files " },
				{ source = "buffers", display_name = " 󰈚 Buffers " },
				{ source = "git_status", display_name = " 󰊢 Git " },
			},
		},
		default_component_configs = {
			indent = {
				indent_size = 2,
				padding = 1,
				with_markers = true,
				indent_marker = "│",
				last_indent_marker = "└",
				expander_collapsed = "",
				expander_expanded = "",
			},
			name = {
				trailing_slash = false,
				use_git_status_colors = true,
			},
			git_status = {
				symbols = {
					added = "",
					modified = "",
					deleted = "✖",
					renamed = "󰁕",
				},
			},
			file_size = { enabled = true, required_width = 64 },
			type = { enabled = true, required_width = 122 },
			last_modified = { enabled = true, required_width = 88 },
			created = { enabled = true, required_width = 110 },
			symlink_target = { enabled = false },
		},
		window = {
			position = "left",
			width = 35,
			mappings = {
				["l"] = "open",
				["h"] = "close_node",
				["s"] = "open_vsplit",
				["S"] = "",
				["t"] = "open_tabnew",
				["w"] = "open_with_window_picker",
				["C"] = "close_node",
				["z"] = "close_all_nodes",
				["a"] = { "add", config = { show_path = "none" } },
				["A"] = "add_directory",
				["d"] = "delete",
				["r"] = "rename",
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["c"] = "copy",
				["m"] = "move",
				["q"] = "close_window",
				["R"] = "refresh",
				["?"] = "show_help",
				["<"] = "prev_source",
				[">"] = "next_source",
				["i"] = "show_file_details",
			},
		},
		filesystem = {
			bind_to_cwd = true,
			cwd_target = {
				sidebar = "tab",
				current = "window",
			},
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_hidden = false,
				hide_by_name = {},
				hide_by_pattern = {},
				always_show = { ".gitignore" },
				never_show = { ".DS_Store" },
				never_show_by_pattern = {},
			},
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
			hijack_netrw_behavior = "open_default",
			use_libuv_file_watcher = true,
		},
		buffers = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
			group_empty_dirs = true,
			show_unloaded = true,
			window = {
				mappings = {
					["dd"] = "buffer_delete",
				},
			},
		},
	},
}
