local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("General", { clear = true })

autocmd("BufWritePre", {
	group = general,
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.setpos(".", save_cursor)
	end,
	desc = "Remove trailing whitespace",
})

autocmd("VimResized", {
	group = general,
	command = "tabdo wincmd =",
	desc = "Auto-resize splits across all tabs",
})

autocmd("BufReadPost", {
	group = general,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
	desc = "Return to last edit position",
})

autocmd("BufWritePre", {
	group = general,
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
	desc = "Auto-create directories on save",
})

autocmd("BufWinEnter", {
	group = general,
	callback = function()
		vim.cmd("set formatoptions-=cro")
	end,
	desc = "Disable auto-comment continuation",
})

autocmd("FileType", {
	group = general,
	pattern = { "qf", "git", "help", "man", "lspinfo", "oil", "query", "checkhealth" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
	desc = "Quick-close transient buffers with q",
})

autocmd("CmdWinEnter", {
	group = general,
	command = "quit",
	desc = "Disable command-line window",
})

autocmd("FocusGained", {
	group = general,
	command = "checktime",
	desc = "Reload buffers changed externally",
})

autocmd({ "VimEnter", "DirChanged" }, {
	group = general,
	callback = function()
		vim.opt.titlestring = vim.fn.getcwd():match("([^/]+)$")
	end,
	desc = "Set window title to project name",
})

autocmd("TextYankPost", {
	group = general,
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 40 })
	end,
	desc = "Highlight on yank",
})

autocmd("FileType", {
	group = general,
	pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
	desc = "Wrap and spell-check prose buffers",
})
