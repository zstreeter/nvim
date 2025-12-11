return {
	"pimalaya/himalaya-vim",
	cmd = { "Himalaya" },
	keys = {
		{ "<leader>mo", "<cmd>Himalaya<cr>", desc = "Open inbox" },
		{ "<leader>mc", "<cmd>HimalayaWrite<cr>", desc = "Compose email" },
		{ "<leader>mf", "<cmd>HimalayaFolders<cr>", desc = "Switch folder" },
	},
	config = function()
		vim.g.himalaya_folder_picker = "telescope"
		vim.g.himalaya_folder_picker_telescope_preview = 1
	end,
}
