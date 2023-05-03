local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.execute_command(params)
end

return {
	commands = {
		OrganizeImports = {
			organize_imports,
			description = "Organize Imports",
		},
	},
	capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	init_options = {
		preferences = {
			importModuleSpecifierPreference = "auto", --non-relative
			maxTsServerMemory = "8192",
		},
	},
}
