-- Background new-mail notifications via the himalaya CLI.
--
-- Deep module with an explicit lifecycle: start(opts) / stop(). Started
-- eagerly from init.lua — it must NOT live behind the lazy himalaya plugin
-- spec, where it only began polling after the first :Himalaya (background
-- notifications that never ran in the background).
--
-- opts.runner is injectable for tests: fun(account, on_done(json_string)).
-- The default runner shells out to himalaya; JSON parsing and per-account
-- unread state are private implementation.
local M = {}

local timer, runner, last_counts

-- himalaya v2 schema: { envelopes = [ { flags = [ {iana="seen"}, ... ] } ] }
-- (v1 was a bare array with string flags like "Seen".)
local function count_unread(json)
	local ok, result = pcall(vim.json.decode, json)
	if not ok or type(result) ~= "table" or type(result.envelopes) ~= "table" then
		vim.notify("mail-notify: unexpected himalaya JSON schema — polling gave no data", vim.log.levels.WARN)
		return nil
	end
	local unread = 0
	for _, envelope in ipairs(result.envelopes) do
		local seen = false
		for _, flag in ipairs(envelope.flags or {}) do
			if flag.iana == "seen" then
				seen = true
				break
			end
		end
		if not seen then
			unread = unread + 1
		end
	end
	return unread
end

local function default_runner(account, on_done)
	vim.fn.jobstart({ "himalaya", "--account", account, "envelope", "list", "--json" }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data and data[1] and data[1] ~= "" then
				on_done(table.concat(data, ""))
			end
		end,
	})
end

local function check_account(account)
	runner(account, function(json)
		local unread = count_unread(json)
		if not unread then
			return
		end
		local prev = last_counts[account]
		if prev ~= nil and unread > prev then
			local new_mail = unread - prev
			vim.notify(
				string.format("%d new email%s in %s", new_mail, new_mail > 1 and "s" or "", account),
				vim.log.levels.INFO,
				{ title = "📬 Mail" }
			)
		end
		last_counts[account] = unread
	end)
end

--- Start polling. opts: accounts (list, required), interval_ms (default 5 min),
--- initial_delay_ms (default 3 s), runner (test injection).
function M.start(opts)
	M.stop()
	opts = opts or {}
	runner = opts.runner or default_runner
	last_counts = {}
	local accounts = opts.accounts or {}

	-- Only the real runner needs the binary; injected runners don't.
	if not opts.runner and vim.fn.executable("himalaya") == 0 then
		return
	end

	local tick = vim.schedule_wrap(function()
		for _, account in ipairs(accounts) do
			check_account(account)
		end
	end)

	timer = vim.uv.new_timer()
	timer:start(opts.initial_delay_ms or 3000, opts.interval_ms or 5 * 60 * 1000, tick)

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = vim.api.nvim_create_augroup("MailNotify", { clear = true }),
		callback = M.stop,
	})
end

function M.stop()
	if timer then
		timer:stop()
		timer:close()
		timer = nil
	end
end

return M
