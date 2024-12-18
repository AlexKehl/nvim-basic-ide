local lsp_config = require("user.lsp")
local cmp_config = require("user.cmp")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"sainnhe/gruvbox-material",
	"nvim-lua/plenary.nvim",
	-- "nvim-lualine/lualine.nvim",
	{ "kylechui/nvim-surround", opts = {} },
	"mhartington/formatter.nvim",
	"terryma/vim-expand-region",
	"tpope/vim-projectionist",
	"chrisbra/Colorizer",
	"christoomey/vim-tmux-navigator",
	{
		"justinmk/vim-sneak",
		init = function()
			vim.cmd([[
        let g:sneak#label = 1
        let g:sneak#use_ic_scs = 1
        let g:sneak#f_reset = 1
        let g:sneak#t_reset = 1
      ]])
		end,
	},
	"numToStr/Comment.nvim",
	"stevearc/oil.nvim",
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = { scope = { enabled = false } },
	},
	"lewis6991/gitsigns.nvim",
	"tpope/vim-fugitive",

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = lsp_config,
	},

	-- Autocompletion
	"L3MON4D3/LuaSnip",
	{
		"saghen/blink.cmp",
		lazy = false, -- lazy loading handled internally
		-- use a release tag to download pre-built binaries
		version = "v0.*",

		opts = {
			keymap = {
				preset = "default",
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<C-e>"] = { "show", "fallback" },

				-- optionally, define different keymaps for cmdline
				-- cmdline = {
				--   preset = 'super-tab'
				-- }
			},
			completion = {
				list = {
					max_items = 200,
					selection = "auto_insert",
				},
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, via `opts_extend`
			sources = {
				default = { "lsp", "path", "buffer" },
				-- optionally disable cmdline completions
				-- cmdline = {},
			},

			-- experimental signature help support
			-- signature = { enabled = true }
		},
		-- allows extending the providers array elsewhere in your config
		-- without having to redefine it
		opts_extend = { "sources.default" },
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
	},
	{
		"gbprod/substitute.nvim",
		opts = {
			highlight_substituted_text = {
				enabled = false,
			},
		},
	},
	-- SQL
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
	},
	"kristijanhusak/vim-dadbod-completion",

	-- music
	"martineausimon/nvim-lilypond-suite",

	{
		"dmmulroy/tsc.nvim",
		opts = {
			auto_open_qflist = false,
			flags = { watch = true, noEmit = true },
			enable_progress_notifications = false,
			enable_error_notifications = false,
			pretty_errors = false,
		},
	},

	{
		"zbirenbaum/copilot.lua",
		opts = {
			panel = {
				enabled = true,
				auto_refresh = false,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
				},
				layout = {
					position = "right", -- | top | left | right | horizontal | vertical
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = true,
				debounce = 75,
				keymap = {
					accept = "<C-]>",
					dismiss = false,
				},
			},
			copilot_node_command = "node", -- Node.js version must be > 18.x
			server_opts_overrides = {
				settings = {
					advanced = {
						listCount = 3, -- #completions for panel
					},
				},
			},
		},
	},

	{
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			dependencies = {
				{ "zbirenbaum/copilot.lua" },
				{ "nvim-lua/plenary.nvim" },
			},
			build = "make tiktoken",
			opts = {
				model = "claude-3.5-sonnet",
				mappings = {
					reset = {
						normal = "",
						insert = "",
					},
				},
			},
		},
	},

	-- Treesitter
	"nvim-treesitter/nvim-treesitter",
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Markdown
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	-- DAP
	{ "mfussenegger/nvim-dap" },
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	-- lazy.nvim
})
