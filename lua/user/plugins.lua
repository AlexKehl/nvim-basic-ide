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
	"nvim-lualine/lualine.nvim",
	{ "kylechui/nvim-surround", opts = {} },
	"mhartington/formatter.nvim",
	"terryma/vim-expand-region",
	"tpope/vim-projectionist",
	"tpope/vim-unimpaired",
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
	-- {
	-- 	"ggandor/leap.nvim",
	-- 	opts = {},
	-- 	init = function()
	-- 		require("leap").create_default_mappings()
	-- 	end,
	-- },
	"numToStr/Comment.nvim",
	"stevearc/oil.nvim",
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = { scope = { enabled = false } },
	},
	-- Git
	"ThePrimeagen/git-worktree.nvim",
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

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = cmp_config,
	},
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-path",

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		tag = "0.1.4",
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
		"samjwill/nvim-unception",
		init = function() end,
	},

	-- SQL
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
	},
	"kristijanhusak/vim-dadbod-completion",

	-- music
	"martineausimon/nvim-lilypond-suite",

	-- Treesitter
	"nvim-treesitter/nvim-treesitter",
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Copilot
	"github/copilot.vim",
})
