-- local function organize_imports()
-- 	local params = {
-- 		command = "_typescript.organizeImports",
-- 		arguments = { vim.api.nvim_buf_get_name(0) },
-- 		title = "",
-- 	}
-- 	vim.lsp.buf.execute_command(params)
-- end

local function go_to_test()
	-- print("go to test")
	--
	-- print(vim.inspect({ vim.uri_from_bufnr(0), vim.fn.line("."), vim.fn.col(".") - 1 }))
	local params = {
		command = "go-to-test",
		arguments = { vim.uri_from_bufnr(0), vim.fn.line("."), vim.fn.col(".") - 1 },
	}

	vim.lsp.buf.execute_command(params)
end

return {
	commands = {
		GoToTest = {
			go_to_test,
			description = "Go to test",
		},
	},
	filetypes = { "clojure" },
}
