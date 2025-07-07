local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
-- local handlers = require("user.lsp.handlers")
-- local lspconfig = require("lspconfig")

mason.setup()
mason_lspconfig.setup()

-- local base_opts = {
-- 	on_attach = handlers.on_attach,
-- 	capabilities = handlers.capabilities,
-- }

-- local function organize_imports()
-- 	vim.lsp.buf.execute_command({
-- 		command = "_typescript.organizeImports",
-- 		arguments = { vim.api.nvim_buf_get_name(0) },
-- 		title = "",
-- 	})
-- end
--
-- local ts_commands = {
-- 	OrganizeImports = {
-- 		organize_imports,
-- 		description = "Organize Imports",
-- 	},
-- }
-- local ts_filetypes = {
-- 	"javascript",
-- 	"javascriptreact",
-- 	"javascript.jsx",
-- 	"typescript",
-- 	"typescriptreact",
-- 	"typescript.tsx",
-- }
--
-- for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
-- 	local opts = {}
--
-- 	if server == "jsonls" then
-- 		-- pull in your per-server jsonls settings
-- 		opts = vim.tbl_deep_extend("force", require("user.lsp.settings.jsonls"), opts)
-- 	elseif server == "ts_ls" then
-- 		opts.commands = ts_commands
-- 		opts.filetypes = ts_filetypes
-- 	end
-- 	--
-- 	lspconfig[server].setup(opts)
-- end
