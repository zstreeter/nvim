-- lua/plugins/catppuccin.lua
return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false, -- make sure we load this during startup
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			background = { -- :h background
				light = "latte",
				dark = "mocha",
			},
			transparent_background = true, -- disables setting the background color.
			show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
			term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = false, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.15, -- percentage of the shade to apply to the inactive window
			},
			no_italic = false, -- Force no italic
			no_bold = false, -- Force no bold
			no_underline = false, -- Force no underline
			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { "italic" }, -- Change the style of comments
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {},
			custom_highlights = function(colors)
				return {
					-- Set backgrounds with alpha values (blend with terminal background)
					Normal = { bg = "NONE", ctermbg = "NONE" },
					NormalNC = { bg = "NONE", ctermbg = "NONE" },
					-- FIXED: Removed blend values for floating windows
					NormalFloat = { bg = colors.base }, -- Solid background, no blend
					FloatBorder = { bg = colors.base, fg = colors.blue }, -- Solid background
					Pmenu = { bg = colors.base }, -- Solid popup menu background
					PmenuSel = { bg = colors.surface0 }, -- Solid selected item background
					-- Telescope with transparency (kept as you might want this)
					TelescopeNormal = { bg = colors.base, blend = 90 },
					TelescopeBorder = { bg = colors.base, blend = 90 },
					-- Neo-tree with slight transparency (kept as sidebar)
					NeoTreeNormal = { bg = colors.mantle, blend = 95 },
					NeoTreeNormalNC = { bg = colors.mantle, blend = 95 },
					-- Statusline and tabline
					StatusLine = { bg = colors.base, blend = 85 },
					StatusLineNC = { bg = colors.base, blend = 85 },
					TabLine = { bg = colors.base, blend = 90 },
					-- Make sidebars slightly transparent
					VertSplit = { bg = "NONE", fg = colors.surface0 },
					WinSeparator = { bg = "NONE", fg = colors.surface0 },
					-- CursorLine with subtle transparency
					CursorLine = { bg = colors.surface0, blend = 95 },
				}
			end,
			default_integrations = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				neotree = true,
				treesitter = true,
				notify = true,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				telescope = {
					enabled = true,
					style = "nvchad",
				},
			},
		})
		-- load the colorscheme here
		vim.cmd([[colorscheme catppuccin]])

		-- Additional transparency settings - FIXED
		vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })

		-- FIXED: Removed the problematic blend settings for floating windows
		if vim.fn.has("nvim-0.10") == 1 then
			-- Keep these with solid backgrounds for readability
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e" }) -- Solid background
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e1e2e", fg = "#89b4fa" }) -- Solid background
			vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1e1e2e" }) -- Solid background
		end
	end,
}
