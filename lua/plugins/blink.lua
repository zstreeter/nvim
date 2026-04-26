return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
		"giuxtaposition/blink-cmp-copilot",
	},
	version = "1.*",
	config = function()
		require("lspkind").init({
			mode = "symbol_text",
			symbol_map = {
				Array = " ",
				Boolean = " ",
				Class = " ",
				Color = " ",
				Constant = " ",
				Constructor = " ",
				Enum = " ",
				EnumMember = " ",
				Event = " ",
				Field = " ",
				File = " ",
				Folder = "󰉋 ",
				Function = " ",
				Interface = " ",
				Key = " ",
				Keyword = " ",
				Method = " ",
				Module = " ",
				Namespace = " ",
				Null = "󰟢",
				Number = " ",
				Object = " ",
				Operator = " ",
				Package = " ",
				Property = " ",
				Reference = " ",
				Snippet = " ",
				String = " ",
				Struct = " ",
				Text = " ",
				TypeParameter = " ",
				Unit = " ",
				Value = " ",
				Variable = " ",
				Codeium = "󰚩 ",
				Copilot = " ",
				LazyDev = "b ",
			},
		})

		require("blink.cmp").setup({
			cmdline = {
				keymap = {
					preset = "inherit",
					["<C-j>"] = { "select_next", "fallback" },
					["<C-k>"] = { "select_prev", "fallback" },
				},
			},
			keymap = {
				preset = "default",
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
			completion = {
				menu = {
					draw = {
						components = {
							kind_icon = {
								text = function(item)
									local kind = require("lspkind").symbol_map[item.kind] or ""
									return kind .. ""
								end,
							},
						},
					},
				},
				documentation = { auto_show = true },
			},
			sources = {
				default = { "copilot", "lazydev", "lsp", "path", "buffer" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
						transform_items = function(_, items)
							local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
							local kind_idx = #CompletionItemKind + 1
							CompletionItemKind[kind_idx] = "Copilot"
							for _, item in ipairs(items) do
								item.kind = kind_idx
							end
							return items
						end,
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
						transform_items = function(_, items)
							local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
							local kind_idx = #CompletionItemKind + 1
							CompletionItemKind[kind_idx] = "LazyDev"
							for _, item in ipairs(items) do
								item.kind = kind_idx
							end
							return items
						end,
					},
				},
			},
		})
	end,
}
