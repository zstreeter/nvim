return {
	"coder/claudecode.nvim",

	dependencies = {
		"folke/snacks.nvim", -- Enhanced terminal support
	},

	config = function()
		-- Detect if we're in an SSH session
		local is_remote = vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil

		require("claudecode").setup({
			-- Core settings
			auto_start = true,
			log_level = "warn", -- Minimal logging, change to "debug" for troubleshooting

			-- Port configuration
			port_range = is_remote and { min = 10000, max = 10000 } -- Fixed port for SSH forwarding
				or { min = 10000, max = 65535 }, -- Flexible range for local

			-- Terminal command - only auto-launch Claude CLI when local
			terminal_cmd = is_remote and nil or "claude",

			-- Terminal appearance with snacks
			terminal = {
				split_side = "right",
				split_width_percentage = 0.3,
				provider = "snacks", -- Use snacks for better terminal experience
				show_native_term_exit_tip = false, -- Not needed with snacks
			},

			-- Diff settings
			diff_opts = {
				auto_close_on_accept = true,
				show_diff_stats = true,
				vertical_split = true,
				open_in_current_tab = true,
			},
		})

		-- Optional: Helpful notification for remote sessions
		if is_remote then
			vim.defer_fn(function()
				if vim.fn.exists(":ClaudeCode") == 2 then
					vim.notify(
						"Claude Code (Remote): Run 'claude --websocket-url ws://localhost:10000' on local machine",
						vim.log.levels.INFO
					)
				end
			end, 100)
		end
	end,

	-- All your original keybindings
	keys = {
		{ "<leader>a", nil, desc = "AI/Claude Code" },

		-- Primary commands
		{ "<leader>ac", "<cmd>ClaudeCodeStart<cr>", desc = "Start Claude" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },

		-- Resume and continue
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },

		-- Buffer and selection
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },

		-- File tree integration
		{
			"<S-s>",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil" },
		},

		-- Diff management
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},

	-- Lazy load when any Claude command is used
	cmd = {
		"ClaudeCode",
		"ClaudeCodeStart",
		"ClaudeCodeFocus",
		"ClaudeCodeSend",
		"ClaudeCodeOpen",
		"ClaudeCodeClose",
		"ClaudeCodeAdd",
		"ClaudeCodeTreeAdd",
		"ClaudeCodeDiffAccept",
		"ClaudeCodeDiffDeny",
	},
}
