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
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/plenary.nvim") -- Useful lua functions used by lots of plugins
	-- use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
	use("kyazdani42/nvim-web-devicons")
	use("nvim-lualine/lualine.nvim")
	use({
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({})
		end,
	})
	use("mhartington/formatter.nvim")

	use("terryma/vim-expand-region")
	use("tpope/vim-projectionist")
	use("tpope/vim-unimpaired")
	use("chrisbra/Colorizer")
	use("christoomey/vim-tmux-navigator")
	use("justinmk/vim-sneak")
	use("numToStr/Comment.nvim")
	-- use("JoosepAlviste/nvim-ts-context-commentstring")
	use({ "stevearc/oil.nvim" })
	use({ "lukas-reineke/indent-blankline.nvim" })

	-- Git
	use("ThePrimeagen/git-worktree.nvim")
	use("lewis6991/gitsigns.nvim")
	use("tpope/vim-fugitive")

	-- Colorschemes
	-- use 'morhetz/gruvbox'
	use({ "sainnhe/gruvbox-material" })

	-- cmp plugins
	use({ "hrsh7th/nvim-cmp" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer" }) -- buffer completions
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip", ft = { "typescript", "javascript" } }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp", ft = { "typescript", "javascript", "sql", "sh", "lua", "python" } })
	use({ "hrsh7th/cmp-nvim-lua", ft = { "lua" } })

	-- snippets
	use({ "L3MON4D3/LuaSnip", ft = { "typescript", "javascript" } }) --snippet engine
	use({ "rafamadriz/friendly-snippets", ft = { "typescript", "javascript" } }) -- a bunch of snippets to use

	-- LSP
	use({ "neovim/nvim-lspconfig", ft = { "typescript", "javascript", "sql", "sh", "lua" } }) -- enable LSP
	use({ "williamboman/mason.nvim", cmd = { "Mason" } })
	use({ "williamboman/mason-lspconfig.nvim", cmd = { "Mason" } })

	-- Telescope
	use({ "nvim-telescope/telescope.nvim" })
	use("nvim-telescope/telescope-ui-select.nvim")
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})

	-- ChatGPT
	use({
		"jackMort/ChatGPT.nvim",
		requires = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"folke/trouble.nvim",
			"nvim-telescope/telescope.nvim",
		},
	})

	use({
		"samjwill/nvim-unception",
		setup = function()
			-- Optional settings go here!
			-- e.g.) vim.g.unception_open_buffer_in_new_tab = true
		end,
    cmd = { "term" },
	})

	-- SQL
	use({
		"kristijanhusak/vim-dadbod-ui",
		requires = "tpope/vim-dadbod",
    cmd = { "DBUI" },
	})
	use("kristijanhusak/vim-dadbod-completion", { cmd = { "DBUI" } })

	-- music
	use("martineausimon/nvim-lilypond-suite")

	-- Treesitter
	use({ "nvim-treesitter/nvim-treesitter", ft = { "typescript", "javascript", "sql", "sh", "lua", "python" } })
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
    ft = { "typescript", "javascript", "sql", "sh", "lua", "python" },
	})

	-- Copilot
	use({ "github/copilot.vim" })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
