return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		panel = {
			keymap = {
				refresh = "r",
				open = "<M-CR>",
			},
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = false,
				dismiss = "<c-h>",
			},
		},
		filetypes = {
			yaml = true,
			markdown = true,
			help = false,
			gitcommit = false,
			gitrebase = false,
			cvs = false,
			["."] = false,
		},
		copilot_node_command = "node",
	},
	init = function()
		vim.g.copilot_nes_debounce = 100
	end,
	keys = {
		{
			"<c-s>",
			function()
				require("copilot.suggestion").toggle_auto_trigger()
			end,
			desc = "Copilot: toggle auto-trigger",
		},
		{
			"<tab>",
			function()
				if require("copilot.suggestion").is_visible() then
					require("copilot.suggestion").accept()
					return "<Ignore>"
				end
				return "<tab>"
			end,
			mode = "i",
			expr = true,
			desc = "Copilot: accept suggestion (or insert tab)",
		},
	},
}
