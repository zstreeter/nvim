local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

keymap("n", "<C-i>", "<C-i>", opts)

keymap("n", "<leader>w", "<cmd>w<cr>", opts)

-- Better window navigation, in terminal mode too: Snacks.terminal() with no cmd
-- is a bottom split, so wincmd reaches it like any other window.
--
-- Floats decline. A floating window has no place in the layout, and wincmd from
-- one lands on the last-accessed window no matter which direction you asked
-- for -- so a picker or lazygit would answer "yes, I moved" to all four. Same
-- rule zfiles' herdr-nav applies over RPC, so SUPER and <m-…> behave alike.
for _, dir in ipairs({ "h", "j", "k", "l" }) do
	keymap({ "n", "t" }, "<m-" .. dir .. ">", function()
		if vim.api.nvim_win_get_config(0).relative == "" then
			vim.cmd.wincmd(dir)
		end
	end, opts)
end
keymap("n", "<m-tab>", "<c-6>", opts)

keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("x", "p", [["_dP]])
keymap("n", "x", '"_x')

-- Comment toggle using built-in gc (Neovim 0.12)
keymap("n", "<leader>/", "gcc", { remap = true, desc = "Comment line" })
keymap("x", "<leader>/", "gc", { remap = true, desc = "Comment selection" })

vim.cmd([[:amenu 10.100 mousemenu.Goto\ Definition <cmd>lua vim.lsp.buf.definition()<CR>]])
vim.cmd([[:amenu 10.110 mousemenu.References <cmd>lua vim.lsp.buf.references()<CR>]])
-- vim.cmd [[:amenu 10.120 mousemenu.-sep- *]]

vim.keymap.set("n", "<RightMouse>", "<cmd>:popup mousemenu<CR>")
vim.keymap.set("n", "<Tab>", "<cmd>:popup mousemenu<CR>")

-- more good
-- keymap({ "n", "o", "x" }, "<s-h>", "^", opts)
-- keymap({ "n", "o", "x" }, "<s-l>", "g_", opts)

-- tailwind bearable to work with
keymap({ "n", "x" }, "j", "gj", opts)
keymap({ "n", "x" }, "k", "gk", opts)
-- keymap("n", "<leader>w", ":lua vim.wo.wrap = not vim.wo.wrap<CR>", opts)

-- Tab navigation
keymap("n", "<s-tab>", "<cmd>tabnew %<cr>", opts)
keymap({ "n" }, "<s-h>", "<cmd>tabp<cr>", opts)
keymap({ "n" }, "<s-l>", "<cmd>tabn<cr>", opts)

vim.api.nvim_set_keymap("t", "<C-;>", "<C-\\><C-n>", opts)
