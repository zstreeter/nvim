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
	config = function()
		vim.g.himalaya_folder_picker = "telescope"
		vim.g.himalaya_folder_picker_telescope_preview = 1

		-- Check for new mail every 5 minutes
		local check_interval = 5 * 60 * 1000 -- milliseconds
		local last_counts = {}

		local function check_account(account)
			vim.fn.jobstart({ "himalaya", "--account", account, "envelope", "list", "--output", "json" }, {
				stdout_buffered = true,
				on_stdout = function(_, data)
					if data and data[1] and data[1] ~= "" then
						local ok, result = pcall(vim.json.decode, table.concat(data, ""))
						if ok and result then
							local unread = 0
							for _, envelope in ipairs(result) do
								if envelope.flags and not vim.tbl_contains(envelope.flags, "Seen") then
									unread = unread + 1
								end
							end

							if last_counts[account] ~= nil and unread > last_counts[account] then
								local new_mail = unread - last_counts[account]
								vim.notify(
									string.format("%d new email%s in %s", new_mail, new_mail > 1 and "s" or "", account),
									vim.log.levels.INFO,
									{ title = "📬 Mail" }
								)
							end
							last_counts[account] = unread
						end
					end
				end,
			})
		end

		local function check_all_mail()
			check_account("gmail")
			-- Uncomment once work account is set up:
			-- check_account("work")
		end

		-- Start checking after Neovim is fully loaded
		vim.defer_fn(function()
			check_all_mail()
			vim.fn.timer_start(check_interval, function()
				check_all_mail()
			end, { ["repeat"] = -1 })
		end, 3000)
	end,
}
