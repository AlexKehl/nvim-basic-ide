return function()
	-- vim.g["conjure#mapping#enable_defaults"] = false
	vim.g["conjure#mapping#prefix"] = " "
	vim.g["conjure#filetypes"] = {
		"clojure",
		"elixir",
		"fennel",
		"janet",
		"javascript",
		"hy",
		"julia",
		"racket",
		"scheme",
		"lua",
		"lisp",
		"python",
		"ruby",
		"rust",
		"php",
		"r",
	}
	-- send the surrounding form with completions so cider-nrepl can infer the receiver class of (.method ...)
	vim.g["conjure#client#clojure#nrepl#completion#with_context"] = true

	vim.g["conjure#mapping#def_word"] = ""
	vim.g["conjure#mapping#doc_word"] = ""

	vim.g["conjure#mapping#eval_visual"] = "e"
	vim.g["conjure#mapping#eval_current_form"] = "ee"
	vim.g["conjure#mapping#eval_root_form"] = ""
	vim.g["conjure#mapping#eval_word"] = "ew"
	vim.g["conjure#mapping#eval_buf"] = "eb"
	vim.g["conjure#mapping#eval_file"] = "ef"
	vim.g["conjure#mapping#eval_marked_form"] = "em"
	-- vim.g["conjure#mapping#log_vsplit"] = "lv"
end
