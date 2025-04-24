local filter_references_with_treesitter = require("user.treesitter").filter_references_with_treesitter
local custom_references_picker = require("user.telescope").custom_references_picker

local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	vim.diagnostic.config({
		virtual_text = false, -- disable virtual text
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.INFO] = "",
				[vim.diagnostic.severity.HINT] = "󰌵",
			},
		},
		update_in_insert = true,
		underline = false,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function custom_lsp_references_with_treesitter()
	vim.lsp.buf.references(nil, {
		on_list = function(options)
			local filtered_references = filter_references_with_treesitter(options.items)

			if #filtered_references == 0 then
				vim.print("No references found")
				return
			end

			if #filtered_references == 1 then
				local reference = filtered_references[1]

				vim.lsp.util.show_document({
					uri = reference.user_data.uri,
					range = reference.user_data.range,
				}, "utf-8")
				return
			end

			options.items = filtered_references
			custom_references_picker(filtered_references)
		end,
	})
end

local function filter_test_references(references)
	local filtered_references = {}

	for _, reference in ipairs(references) do
		local escaped_path = vim.uri_to_fname(reference.user_data.uri)
		local buf = vim.fn.bufnr(escaped_path)

		if buf == -1 then
			goto continue
		end

		if not string.find(escaped_path, "test") then
			goto continue
		end

		local node = vim.treesitter.get_node({
			bufnr = buf,
			pos = {
				reference.user_data.range.start.line,
				reference.user_data.range.start.character,
			},
			-- lang = vim.bo.filetype,
		})

		table.insert(filtered_references, reference)

		::continue::
	end

	return filtered_references
end

local function go_to_test()
	vim.lsp.buf.references(nil, {
		on_list = function(options)
			local filtered_references = filter_test_references(options.items)

			if #filtered_references == 0 then
				vim.print("No references found")
				return
			end

			local first = filtered_references[1]

			local reference = filtered_references[1]

			vim.lsp.util.show_document({
				uri = reference.user_data.uri,
				range = reference.user_data.range,
			}, "utf-8")
			return
		end,
	})
end

local code_action_filter = function(code_action)
	if string.find(code_action.command.title, "Add") or string.find(code_action.command.title, "Update") then
		return true
	else
		return false
	end
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gy", ":Telescope lsp_type_definitions show_line=false<CR>", opts)
	keymap(bufnr, "n", "gd", ":Telescope lsp_definitions show_line=false<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gi", ":Telescope lsp_implementations show_line=false<CR>", opts)
	vim.keymap.set("n", "gr", custom_lsp_references_with_treesitter, opts)
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	-- keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
	-- keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
	-- keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
	vim.keymap.set("n", "<leader>f", function()
		if vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" then
			vim.lsp.buf.code_action({ filter = code_action_filter })
		else
			vim.lsp.buf.code_action()
		end
	end, opts)
	keymap(bufnr, "n", "<leader>F", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	keymap(bufnr, "n", "]g", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
	keymap(bufnr, "n", "[g", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
	keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	vim.keymap.set("n", "gt", go_to_test, opts)
	-- keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	-- keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end

M.on_attach = function(client, bufnr)
	if client.name == "ts_ls" then
		client.server_capabilities.document_formatting = false
	end

	if client.name == "sumneko_lua" then
		client.server_capabilities.document_formatting = false
	end

	if client.name == "gleam" then
		client.server_capabilities.documentFormattingProvider = true
	end

	lsp_keymaps(bufnr)
end

-- gotta have lspconfig imported with you pmanager, I reckon
local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

lspconfig.gleam.setup({
	cmd = { "gleam", "lsp" },
	filetypes = { "gleam" },
	root_dir = lspconfig.util.root_pattern("gleam.toml", ".git"),
	on_attach = M.on_attach,
	capabilities = M.capabilities,
})

lspconfig.fennel_ls.setup({})

return M
