-- Custom blink.cmp source that extracts Clojure namespaced keywords (e.g. :ns/name)
-- from open buffers. The built-in buffer source splits on '/' so it can't handle these.
local source = {}
source.new = function()
	return setmetatable({}, { __index = source })
end
source.enabled = function(_self)
	return (vim.bo.filetype == "clojure")
end
source.get_completions = function(_self, _, callback)
	local items = {}
	local seen = {}
	local kind_text = require("blink.cmp.types").CompletionItemKind.Text
	local plain_text = vim.lsp.protocol.InsertTextFormat.PlainText
	for _0, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			for _1, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
				-- Match optional leading colon, namespace, slash, name, e.g. :Listing/maxPetsAllowed
				for word in line:gmatch(":?[%w%-%._]+/[%w%-%._]+") do
					if not seen[word] then
						seen[word] = true
						table.insert(
							items,
							{ label = word, kind = kind_text, insertTextFormat = plain_text, insertText = word }
						)
					end
				end
			end
		end
	end
	return callback({ items = items, is_incomplete_backward = false, is_incomplete_forward = false })
end
return source
