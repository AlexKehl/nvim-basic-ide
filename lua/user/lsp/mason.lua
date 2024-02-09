local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local handlers = require("user.lsp.handlers")

mason.setup()
mason_lspconfig.setup()

local opts = {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}

-- require("lspconfig").sqls.setup({
-- 	on_attach = function(client, bufnr)
-- 		require("sqls").on_attach(client, bufnr)
-- 	end,
-- 	cmd = { "/Users/alexanderkehl/go/bin/sqls" },
-- 	settings = {
-- 		sqls = {
-- 			connections = {
-- 				{
-- 					driver = "postgresql",
-- 					dataSourceName = "host=127.0.0.1 port=5432 user=admin password=mysecretpassword dbname=steam_api sslmode=disable",
-- 				},
-- 			},
--       sshConfig = {
--         host = "my-ssh-host",
--         port = 22,
--         user
--       }
-- 		},
-- 	},
-- })

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			on_attach = handlers.on_attach,
			capabilities = handlers.capabilities,
		})
	end,
	-- ["sumneko_lua"] = function()
	-- 	local lua_opts = require("user.lsp.settings.sumneko_lua")
	-- 	local extended_opts = vim.tbl_deep_extend("force", lua_opts, opts)
	-- 	require("lspconfig")["sumneko_lua"].setup(extended_opts)
	-- end,
	["jsonls"] = function()
		local json_opts = require("user.lsp.settings.jsonls")
		local extended_opts = vim.tbl_deep_extend("force", json_opts, opts)
		require("lspconfig")["jsonls"].setup(extended_opts)
	end,
	["tsserver"] = function()
		local ts_opts = require("user.lsp.settings.tsserver")
		local extended_opts = vim.tbl_deep_extend("force", ts_opts, opts)
		require("lspconfig")["tsserver"].setup(extended_opts)
	end,
	["pyright"] = function()
		local pyright_opts = require("user.lsp.settings.pyright")
		local extended_opts = vim.tbl_deep_extend("force", pyright_opts, opts)
		require("lspconfig")["pyright"].setup(extended_opts)
	end,
	["rust_analyzer"] = function()
		local rust_opts = require("user.lsp.settings.rust")
		local extended_opts = vim.tbl_deep_extend("force", rust_opts, opts)
		require("lspconfig")["rust_analyzer"].setup(extended_opts)
	end,
})
