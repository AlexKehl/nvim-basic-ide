return function()
	require("user.lsp.mason")
	require("user.lsp.handlers").setup()

	local orig_notify = vim.notify
	vim.notify = function(msg, level, opts)
		if type(msg) == "string" and msg:match("^Client sqls quit") then
			return
		end
		return orig_notify(msg, level, opts)
	end
end
