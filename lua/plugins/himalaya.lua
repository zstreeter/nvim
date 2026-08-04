return {
	"pimalaya/himalaya-vim",
	cmd = { "Himalaya" },
	keys = {
		-- Inbox & Navigation
		{ "<leader>mo", "<cmd>Himalaya<cr>", desc = "Open inbox (default)" },
		{ "<leader>mO", ":Himalaya ", desc = "Open account..." },
		{ "<leader>mf", "<plug>(himalaya-folder-select)", desc = "Switch folder" },
		{ "<leader>mn", "<plug>(himalaya-folder-select-next-page)", desc = "Next page" },
		{ "<leader>mp", "<plug>(himalaya-folder-select-previous-page)", desc = "Previous page" },
		{ "<leader>m/", "<plug>(himalaya-set-list-envelopes-query)", desc = "Search/filter" },
		{ "<leader>me", "<plug>(himalaya-email-read)", desc = "Read email" },
		{
			"<leader>ms",
			function()
				vim.notify("Syncing mail...", vim.log.levels.INFO, { title = "Mail" })
				vim.fn.jobstart({ "himalaya", "envelope", "list" }, {
					on_exit = function(_, code)
						if code == 0 then
							vim.notify("Mail synced", vim.log.levels.INFO, { title = "Mail" })
						else
							vim.notify("Sync failed", vim.log.levels.ERROR, { title = "Mail" })
						end
					end,
				})
			end,
			desc = "Sync mail",
		},

		-- Compose & Reply
		{ "<leader>mc", "<plug>(himalaya-email-write)", desc = "Compose new" },
		{ "<leader>mr", "<plug>(himalaya-email-reply)", desc = "Reply" },
		{ "<leader>mR", "<plug>(himalaya-email-reply-all)", desc = "Reply all" },
		{ "<leader>mF", "<plug>(himalaya-email-forward)", desc = "Forward" },

		-- Actions
		{ "<leader>ma", "<plug>(himalaya-email-download-attachments)", desc = "Download attachments" },
		{ "<leader>mC", "<plug>(himalaya-email-copy)", desc = "Copy to folder" },
		{ "<leader>mM", "<plug>(himalaya-email-move)", desc = "Move to folder" },
		{ "<leader>md", "<plug>(himalaya-email-delete)", desc = "Delete" },

		-- Flags
		{ "<leader>m+", "<plug>(himalaya-email-flag-add)", desc = "Add flag" },
		{ "<leader>m-", "<plug>(himalaya-email-flag-remove)", desc = "Remove flag" },

		-- Quick account access
		{ "<leader>mg", "<cmd>Himalaya gmail<cr>", desc = "Gmail inbox" },
		{ "<leader>mw", "<cmd>Himalaya work<cr>", desc = "Work inbox" },
	},
	-- New-mail polling lives in config/mail-notify.lua (started from
	-- init.lua) — NOT here: this spec is lazy (cmd/keys), so anything in
	-- config only runs after the first :Himalaya. The old telescope picker
	-- settings were dead — telescope is not installed.
}
