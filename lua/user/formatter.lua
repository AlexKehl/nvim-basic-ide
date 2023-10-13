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
			-- html = { prettier },
			yaml = { prettier },
			-- javascript = { prettier },
			javascriptreact = { prettier },
			typescript = { prettier },
			typescriptreact = { prettier },
			markdown = { prettier },
			json = { prettier },
			jsonc = { prettier },
			rust = { rustfmt },
			ocaml = { ocamlformat },
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
		},
	})

	local group = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePost", {
		command = "FormatWrite",
		group = group,
		pattern = "*",
	})
end
