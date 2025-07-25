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
					NormalFloat = { bg = colors.base, blend = 80 }, -- 80% opacity
					FloatBorder = { bg = colors.base, blend = 80 },
					Pmenu = { bg = colors.base, blend = 85 }, -- Popup menu with 85% opacity
					PmenuSel = { bg = colors.surface0, blend = 85 },
					-- Telescope with transparency
					TelescopeNormal = { bg = colors.base, blend = 90 },
					TelescopeBorder = { bg = colors.base, blend = 90 },
					-- Neo-tree with slight transparency
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
				nvimtree = true,
				treesitter = true,
				notify = false,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				telescope = {
					enabled = true,
					style = "nvchad",
				},
				neotree = true,
				which_key = true,
				-- Add more integrations as needed
			},
		})
		-- load the colorscheme here
		vim.cmd([[colorscheme catppuccin]])

		-- Additional transparency settings with alpha values
		-- This works if your terminal supports true transparency
		vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })

		-- If you want to set specific alpha values for certain highlights
		-- and your terminal supports it (like Kitty, Alacritty with blur)
		if vim.fn.has("nvim-0.10") == 1 then
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", blend = 80 })
			vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", blend = 85 })
			vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE", blend = 90 })
		end
	end,
}
