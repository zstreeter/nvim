return {
	"pablopunk/pi.nvim",
	cmd = { "PiAsk", "PiAskSelection", "PiCancel", "PiLog" },
	opts = {
		-- Leave provider/model unset to use pi's default config (`pi --list-models`).
		-- Examples:
		--   { provider = "openrouter", model = "moonshotai/kimi-k2.5" }
		--   { provider = "openrouter", model = "deepseek/deepseek-chat" }
		--   { provider = "anthropic",  model = "claude-haiku-4-5" }
		max_context_lines = 300,
		max_context_bytes = 24000,
		selection_context_lines = 40,
	},
	config = function(_, opts)
		require("pi").setup(opts)
	end,
	keys = {
		{ "<leader>ap", "<cmd>PiAsk<cr>", mode = "n", desc = "AI: Pi ask" },
		{ "<leader>ap", "<cmd>PiAskSelection<cr>", mode = "v", desc = "AI: Pi ask (selection)" },
	},
}
