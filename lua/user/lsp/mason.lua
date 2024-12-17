local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local handlers = require("user.lsp.handlers")

mason.setup()
mason_lspconfig.setup()

local opts = {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			on_attach = handlers.on_attach,
			capabilities = handlers.capabilities,
		})
	end,
	["jsonls"] = function()
		local json_opts = require("user.lsp.settings.jsonls")
		local extended_opts = vim.tbl_deep_extend("force", json_opts, opts)
		require("lspconfig")["jsonls"].setup(extended_opts)
	end,
	["ts_ls"] = function()
		local ts_opts = require("user.lsp.settings.ts_ls")
		local extended_opts = vim.tbl_deep_extend("force", ts_opts, opts)
		require("lspconfig")["ts_ls"].setup(extended_opts)
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
	["elixirls"] = function()
    local elixir_opts = {
      cmd = { "elixir-ls" },
      filetypes = { "elixir" },
      root_dir = require("lspconfig.util").root_pattern("mix.exs", ".git"),
      settings = {
        elixirLS = {
          dialyzerEnabled = true,
          dialyzerFormat = "dialyxir_long",
        },
      },
    }
		local extended_opts = vim.tbl_deep_extend("force", elixir_opts, opts)
		require("lspconfig")["elixirls"].setup(extended_opts)
	end,
})
