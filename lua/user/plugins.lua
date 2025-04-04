local lsp_config = require("user.lsp")
local conjure = require("user.conjure")
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
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
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
				model = "claude-3.7-sonnet",
				mappings = {
					reset = {
						normal = "",
						insert = "",
					},
				},
			},
		},
	},

	{
		"Olical/conjure",
		ft = { "clojure", "fennel" },
		lazy = true,
		init = conjure,
	},
	{ "guns/vim-sexp" },
	{ "tpope/vim-sexp-mappings-for-regular-people" },
	{ "HiPhish/rainbow-delimiters.nvim", ft = { "clojure" } },
	{ "eraserhd/parinfer-rust", build = "cargo build --release" },
  {'raystubbs/nvim-cljfmt-indents',
    config = function()
      require('nvim-cljfmt-indents').setup()
    end
  },
	{ "brianhuster/live-preview.nvim" },

	{
		"hat0uma/csvview.nvim",
		---@module "csvview"
		---@type CsvView.Options
		opts = {
			parser = {
				comments = { "#", "//" },
				delimiter = {
					default = ";",
					-- ft = {
					--   tsv = "\t",
					-- },
				},
			},
			keymaps = {
				-- Text objects for selecting fields
				textobject_field_inner = { "if", mode = { "o", "x" } },
				textobject_field_outer = { "af", mode = { "o", "x" } },
				-- Excel-like navigation:
				-- Use <Tab> and <S-Tab> to move horizontally between fields.
				-- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
				-- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
				jump_next_field_start = { "W", mode = { "n", "v" } },
				jump_prev_field_start = { "B", mode = { "n", "v" } },
				jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
				jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
				jump_next_row = { "<Enter>", mode = { "n", "v" } },
				jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
			},
		},
		cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle", "CsvViewDelimiter" },
	},

	{
		"andrewferrier/debugprint.nvim",
		opts = {
			keymaps = {
				normal = {
					plain_below = "<leader>ej",
					plain_above = "<leader>ek",
					variable_below = "<leader>ew",
					-- variable_above = "g?V",
					variable_below_alwaysprompt = "",
					variable_above_alwaysprompt = "",
					textobj_below = "<leader>ee",
					textobj_above = "g?O",
					toggle_comment_debug_prints = "",
					delete_debug_prints = "<leader>ed",
				},
				insert = {
					plain = "<C-G>p",
					variable = "<C-G>v",
				},
				visual = {
					variable_below = "<leader>e",
					variable_above = "g?V",
				},
			},
			commands = {
				toggle_comment_debug_prints = "ToggleCommentDebugPrints",
				delete_debug_prints = "DeleteDebugPrints",
				reset_debug_prints_counter = "ResetDebugPrintsCounter",
			},
			-- … Other options
		},

		-- opts = { … },

		dependencies = {
			"echasnovski/mini.nvim", -- Needed for :ToggleCommentDebugPrints(NeoVim 0.9 only)
			-- and line highlighting (optional)
		},

		lazy = false, -- Required to make line highlighting work before debugprint is first used
		version = "*", -- Remove if you DON'T want to use the stable version
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
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

		init = function()
			vim.g.mkdp_theme = "light" -- or 'light'
			-- Optional: use GitHub's markdown styling
			-- vim.g.mkdp_markdown_css =
			-- 	"https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown.min.css"
		end,
	},
})
