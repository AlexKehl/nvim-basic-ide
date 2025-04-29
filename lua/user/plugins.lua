local lsp_config = require("user.lsp")
local conjure = require("user.conjure")
local cmp_config = require("user.cmp")
local avante_config = require("user.avante")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		dir = "~/.config/nvim/lua/parinfer-rust",
		name = "parinfer-rust",
		ft = { "clojure", "fennel" },
		build = "cargo build --release",
		dependencies = { "guns/vim-sexp", "tpope/vim-sexp-mappings-for-regular-people" },
		config = function()
			require("parinfer-rust").setup()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
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

	-- "zbirenbaum/copilot.lua",

	{
		"Olical/conjure",
		ft = { "clojure", "fennel" },
		lazy = true,
		init = conjure,
	},
	{ "Olical/nfnl" },
	{
		"guns/vim-sexp",
		init = function()
			vim.cmd([[
		    let g:sexp_filetypes = ''
		    ]])
		end,
	},
	-- { "tpope/vim-sexp-mappings-for-regular-people" },
	{ "HiPhish/rainbow-delimiters.nvim", ft = { "clojure", "fennel" } },
	-- { "eraserhd/parinfer-rust", build = "cargo build --release" },
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
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
	},

	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		opts = avante_config,
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			-- "echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},

	-- Markdown
	{
		-- Install markdown preview, use npx if available.
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function(plugin)
			if vim.fn.executable("npx") then
				vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
			else
				vim.cmd([[Lazy load markdown-preview.nvim]])
				vim.fn["mkdp#util#install"]()
			end
		end,
		init = function()
			if vim.fn.executable("npx") then
				vim.g.mkdp_filetypes = { "markdown" }
			end
			vim.g.mkdp_theme = "light" -- or 'light'
		end,
	},
})
