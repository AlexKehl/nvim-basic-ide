return function()
	vim.cmd([[
    " let g:conjure#mapping#doc_word = ""
    " let g:conjure#mapping#def_word = ""
    " let g:conjure#mapping#def_word = ""

    " let g:conjure#mapping#enable_defaults = false
    " let g:conjure#mapping#prefix = " "
    " let g:conjure#mapping#eval_visual = "e"

    ]])

  vim.g["conjure#mapping#enable_defaults"] = false
	vim.g["conjure#mapping#prefix"] = " "
	vim.g["conjure#mapping#eval_visual"] = "e"
	vim.g["conjure#filetype#sql"] = ""
	vim.g["conjure#mapping#def_word"] = ""
	vim.g["conjure#mapping#doc_word"] = ""

	local function eval_clojure_tests()
		if not (vim.bo.filetype == "clojure") then
			return
		end
		local file_name = vim.api.nvim_buf_get_name(0)

		if string.find(file_name, "_test") then
			return vim.cmd("ConjureCljRunCurrentNsTests")
		end

		vim.cmd("ConjureCljRunAlternateNsTest")
	end

	vim.keymap.set("n", "<C-t>", eval_clojure_tests, {})
end
