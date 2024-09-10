local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = { "tsx", "lua", "rust", "typescript", "javascript" },
	ignore_install = { "" }, -- List of parsers to ignore installing
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python", "css" } },
	-- context_commentstring = {
	-- 	enable = true,
	-- 	enable_autocmd = false,
	-- 	config = {
	-- 		typescript = { __default = "// %s", __multiline = "/* %s */" },
	-- 	},
	-- },
	highlight = {
		enable = true,

		disable = function(_, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
	-- incremental_selection = {
	-- 	enable = true,
	-- 	keymaps = {
	-- 		node_incremental = "v",
	-- 		node_decremental = "<C-v>",
	-- 	},
	-- },
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ic"] = "@conditional.inner",
				["ac"] = "@conditional.outer",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next = {
				["]f"] = "@function.outer",
				["]a"] = "@parameter.outer",
				["]d"] = "@conditional.outer",
				-- next string
				["]s"] = "@string.inner",
			},
			goto_previous = {
				["[f"] = "@function.outer",
				["[a"] = "@parameter.outer",
				["[d"] = "@conditional.outer",
				-- previous string
				["[s"] = "@string.inner",
			},
		},
	},
})
