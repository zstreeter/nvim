return {
	"folke/sidekick.nvim",
	event = "VeryLazy",
	opts = {
		cli = {
			mux = {
				backend = "zellij",
				enabled = true,
			},
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "sidekick_terminal",
			callback = function(event)
				local opts = { buffer = event.buf, noremap = true, silent = true }
				vim.keymap.set("t", "<m-h>", "<C-\\><C-n><C-w>h", opts)
				vim.keymap.set("t", "<m-j>", "<C-\\><C-n><C-w>j", opts)
				vim.keymap.set("t", "<m-k>", "<C-\\><C-n><C-w>k", opts)
				vim.keymap.set("t", "<m-l>", "<C-\\><C-n><C-w>l", opts)
			end,
			desc = "Window navigation in sidekick terminal",
		})
	end,
	keys = {
		{
			"<leader>as",
			function()
				require("sidekick.cli").select()
			end,
			mode = "n",
			desc = "AI: Sidekick (CLI picker)",
		},
		{
			"<leader>as",
			function()
				require("sidekick.cli").send({ selection = true })
			end,
			mode = "v",
			desc = "AI: Sidekick send selection",
		},
	},
}
