local lsp_config = require("user.lsp")

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

	"L3MON4D3/LuaSnip",

	-- Autocompletion
	{
		"saghen/blink.cmp",
		lazy = false,
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
			enable_progress_notifications = true,
			enable_error_notifications = true,
			pretty_errors = false,
		},
	},

	-- Copilot
	"github/copilot.vim",
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

	{ "Olical/conjure" },
	-- { "guns/vim-sexp" },
	-- { "tpope/vim-sexp-mappings-for-regular-people" },
	{
		"julienvincent/nvim-paredit",
		config = function()
			require("nvim-paredit").setup()
		end,
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
