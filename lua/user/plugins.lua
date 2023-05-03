local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use({ "wbthomason/packer.nvim" }) -- Have packer manage itself
	use({ "nvim-lua/plenary.nvim" }) -- Useful lua functions used by lots of plugins
	use({ "windwp/nvim-autopairs" }) -- Autopairs, integrates with both cmp and treesitter
	use({ "kyazdani42/nvim-web-devicons" })
	use({ "nvim-lualine/lualine.nvim" })
	use({ "lewis6991/impatient.nvim" })
	use({
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({})
		end,
	})
	use({ "mhartington/formatter.nvim" })

	use("tpope/vim-fugitive")
	use("terryma/vim-expand-region")
	use("tpope/vim-projectionist")
	use("tpope/vim-unimpaired")
	use("airblade/vim-gitgutter")
	use("diepm/vim-rest-console")
	use("dyng/ctrlsf.vim")
	use("kevinhwang91/rnvimr")
	use("chrisbra/Colorizer")
	use("christoomey/vim-tmux-navigator")
	use("ton/vim-bufsurf")
	use("justinmk/vim-sneak")
	use({ "numToStr/Comment.nvim" })
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use({ "stevearc/oil.nvim" })
	-- use({
	-- 	"jose-elias-alvarez/typescript.nvim",
	-- 	config = function()
	-- 		require("typescript").setup({
	-- 			disable_commands = false, -- prevent the plugin from creating Vim commands
	-- 			debug = false, -- enable debug logging for commands
	-- 			go_to_source_definition = {
	-- 				fallback = true, -- fall back to standard LSP definition on failure
	-- 			},
	-- 			server = { -- pass options to lspconfig's setup method
	-- 				-- on_attach = ...,
	-- 			},
	-- 		})
	-- 	end,
	-- })

	-- Colorschemes
	-- use 'morhetz/gruvbox'
	use({ "sainnhe/gruvbox-material" })
	use("ellisonleao/gruvbox.nvim")

	-- visual
	use("j-hui/fidget.nvim")

	-- cmp plugins
	use({ "hrsh7th/nvim-cmp" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer" }) -- buffer completions
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lua" })

	-- snippets
	use({ "L3MON4D3/LuaSnip" }) --snippet engine
	use({ "rafamadriz/friendly-snippets" }) -- a bunch of snippets to use

	-- LSP
	use({ "neovim/nvim-lspconfig" }) -- enable LSP
	-- use({ "williamboman/nvim-lsp-installer" }) -- simple to use language server installer
	use({ "williamboman/mason.nvim" })
	use({ "williamboman/mason-lspconfig.nvim" })

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-ui-select.nvim")
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})

	-- Treesitter
	use({ "nvim-treesitter/nvim-treesitter" })

	-- Copilot
	use({ "github/copilot.vim" })

	-- DAP
	use({ "mfussenegger/nvim-dap" })
	use({ "rcarriga/nvim-dap-ui" })
	use({ "ravenxrz/DAPInstall.nvim" })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
