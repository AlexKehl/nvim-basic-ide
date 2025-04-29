-- Use 'q' to quit from common plugins
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir" },
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]])
	end,
})

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

local keymap_opts = { noremap = true, silent = true, buffer = true }

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact" },
	callback = function()
		vim.keymap.set("n", "<leader>or", "<cmd>OrganizeImports<CR>", keymap_opts)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "csv", "tsv" },
	desc = "Enable CSV View on .csv files",
	callback = function()
		require("csvview").enable()
		vim.opt_local.formatoptions:remove("t")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "clojure", "scheme", "lisp", "racket", "fennel"},
	desc = "Remove some keymaps from vim-sexp",
	callback = function()
		vim.cmd("nunmap <buffer> <LocalLeader>w")
		vim.cmd("xunmap <buffer> <LocalLeader>w")
		-- remove auto pairs
		vim.cmd("iunmap <buffer> <BS>")
		vim.cmd('iunmap <buffer> "')
		vim.cmd("iunmap <buffer> (")
		vim.cmd("iunmap <buffer> )")
		vim.cmd("iunmap <buffer> [")
		vim.cmd("iunmap <buffer> ]")
		vim.cmd("iunmap <buffer> {")
		vim.cmd("iunmap <buffer> }")

		vim.keymap.set("n", "<Left>", "<Plug>(sexp_emit_tail_element)", keymap_opts)
		vim.keymap.set("n", "<Right>", "<Plug>(sexp_capture_next_element)", keymap_opts)

		vim.keymap.set("n", "<S-Right>", "<Plug>(sexp_emit_head_element)", keymap_opts)
		vim.keymap.set("n", "<S-Left>", "<Plug>(sexp_capture_prev_element)", keymap_opts)

		vim.keymap.set("n", "<Tab>", "<cmd>ParinferToggle<CR>", keymap_opts)

		-- vim.bo.indentexpr = ""
		-- vim.opt.indentexpr = ""
		-- vim.opt.autoindent = true
		-- vim.bo.cindent = false
		-- vim.opt.smartindent = true

		-- vim.opt.smartindent = false
		-- vim.bo.cindent = false
		-- vim.bo.lisp = true
		--
		-- vim.bo.lispwords =
		-- 	"defn def defmacro defmethod defschema defprotocol defrecord let letfn fn loop if if-let when when-let cond case do doseq for"
		--     syntax on
		-- filetype plugin indent on
		-- vim.bo.syntax = "lisp"
	end,
})
