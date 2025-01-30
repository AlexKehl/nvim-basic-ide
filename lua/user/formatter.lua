local present, formatter = pcall(require, "formatter")

if present then
	local prettier = function()
		local filepath = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
		-- Escape the braces
		filepath = filepath:gsub("%(", "\\(")
		filepath = filepath:gsub("%)", "\\)")

		return {
			exe = "cat " .. filepath .. " | prettierd ",
			args = { filepath },
			stdin = true,
		}
	end

	local rustfmt = function()
		return {
			exe = "rustfmt",
			-- args = { vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
			stdin = true,
		}
	end

	local ocamlformat = function()
		return {
			exe = "ocamlformat",
			args = { "--enable-outside-detected-project", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
			stdin = true,
		}
	end

	local elixirformat = function()
		local filepath = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
		-- Escape the braces
		filepath = filepath:gsub("%(", "\\(")
		filepath = filepath:gsub("%)", "\\)")

		return {
			exe = "cat " .. filepath .. " | mix format -",
			stdin = true,
		}
	end

	local gleamformat = function()
		local filepath = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
		-- Escape the braces
		filepath = filepath:gsub("%(", "\\(")
		filepath = filepath:gsub("%)", "\\)")

		return { exe = "gleam format" }
	end

	local lspformat = function()
		vim.lsp.buf.format()
	end

	local shfmt = function()
		return {
			exe = "shfmt",
			args = { "-i", "2", "-ci", "-s" },
			stdin = true,
		}
	end

	local cformat = function()
		return {
			exe = "clang-format",
			args = { vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
			stdin = true,
		}
	end

	formatter.setup({
		logging = false,
		log_level = vim.log.levels.WARN,
		filetype = {
			lua = {
				require("formatter.filetypes.lua").stylua,
			},
			vue = { prettier },
			css = { prettier },
			less = { prettier },
			scss = { prettier },
			html = { lspformat },
			yaml = { prettier },
			javascript = { prettier },
			javascriptreact = { prettier },
			typescript = { prettier },
			typescriptreact = { prettier },
			markdown = { prettier },
			elixir = { elixirformat },
			json = { prettier },
			jsonc = { prettier },
			gleam = { gleamformat },
			clojure = { lspformat },
			rust = { rustfmt },
			ocaml = { ocamlformat },
			sh = { shfmt },
			sql = {
				function()
					return {
						exe = "cat " .. vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) .. " | sql-formatter",
						stdin = true,
					}
				end,
			},
			java = {
				function()
					return {
						exe = "google-java-format",
						args = { vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
						stdin = true,
					}
				end,
			},
			xml = {
				function()
					return {
						exe = "xmllint",
						args = { "--format", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
						stdin = true,
					}
				end,
			},
			python = {
				function()
					return {
						exe = "cat " .. vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) .. " | black --quiet -",
						stdin = true,
					}
				end,
			},
			c = { cformat },
			arduino = { cformat },
		},
	})
end
