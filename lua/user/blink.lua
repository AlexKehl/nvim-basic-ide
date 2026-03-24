return {
	keymap = {
		preset = "default",
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<C-e>"] = { "show", "fallback" },
		["<C-y>"] = false,
		["<C-l>"] = { "scroll_documentation_down", "fallback" },
		["<C-h>"] = { "scroll_documentation_up", "fallback" },

		-- optionally, define different keymaps for cmdline
		-- cmdline = {
		--   preset = 'super-tab'
		-- }
	},
	completion = {
		list = {
			max_items = 200,
			selection = { auto_insert = true, preselect = false },
		},
		menu = {
			auto_show = function(ctx)
				-- return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
				-- return ctx.mode ~= "cmdline"
				return true
			end,
		},
		documentation = {
			-- Controls whether the documentation window will automatically show when selecting a completion item
			auto_show = true,
			-- Delay before showing the documentation window
			auto_show_delay_ms = 0,
			-- Delay before updating the documentation window when selecting a new item,
			-- while an existing item is still visible
			-- update_delay_ms = 0,
			-- Whether to use treesitter highlighting, disable if you run into performance issues
			treesitter_highlighting = true,
			window = {
				min_width = 10,
				max_width = 60,
				max_height = 20,
				border = "padded",
				winblend = 0,
				winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
				-- Note that the gutter will be disabled when border ~= 'none'
				scrollbar = true,
				-- Which directions to show the documentation window,
				-- for each of the possible menu window directions,
				-- falling back to the next direction when there's not enough space
				direction_priority = {
					menu_north = { "e", "w", "n", "s" },
					menu_south = { "e", "w", "s", "n" },
				},
			},
		},
	},

	appearance = {
		-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	-- default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, via `opts_extend`
	sources = {
		default = { "lsp", "path", "buffer", "dadbod", "clojure_keywords" },
		providers = {
			lsp = {
				name = "LSP",
				module = "blink.cmp.sources.lsp",
				score_offset = 50, -- Boost/penalize the score of the items
			},
			path = {
				name = "Path",
				module = "blink.cmp.sources.path",
				score_offset = 3,
			},
			buffer = {
				name = "Buffer",
				module = "blink.cmp.sources.buffer",
			},
			clojure_keywords = {
				name = "Clojure Keywords",
				module = "user.blink-clojure-keywords",
			},
			dadbod = {
				name = "Dadbod",
				module = "vim_dadbod_completion.blink",
				score_offset = 50,
			},
		},
	},
}
