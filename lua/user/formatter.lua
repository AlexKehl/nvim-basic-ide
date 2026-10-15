local present, formatter = pcall(require, "formatter")
if present then
	local function prettier()
		local filepath = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
		filepath = filepath:gsub("%(", "\\(")
		filepath = filepath:gsub("%)", "\\)")
		return { args = { filepath }, exe = ("cat " .. filepath .. " | prettierd "), stdin = true }
	end
	local function rustfmt()
		return { exe = "rustfmt", stdin = true }
	end
	local function ocamlformat()
		return {
			args = { "--enable-outside-detected-project", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
			exe = "ocamlformat",
			stdin = true,
		}
	end
	local function elixirformat()
		local filepath = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
		filepath = filepath:gsub("%(", "\\(")
		filepath = filepath:gsub("%)", "\\)")
		return { exe = ("cat " .. filepath .. " | mix format -"), stdin = true }
	end
	local function gleamformat()
		local filepath = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
		filepath = filepath:gsub("%(", "\\(")
		filepath = filepath:gsub("%)", "\\)")
		return { exe = "gleam format" }
	end
	local function lspformat()
		return vim.lsp.buf.format()
	end
	local function shfmt()
		return { args = { "-i", "2", "-ci", "-s" }, exe = "shfmt", stdin = true }
	end
	local function cformat()
		return { args = { vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) }, exe = "clang-format", stdin = true }
	end
	local function clojureformat()
		local filepath = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
		filepath = filepath:gsub("%(", "\\(")
		filepath = filepath:gsub("%)", "\\)")
		return { exe = "/opt/homebrew/bin/zprint -w" }
	end
	local function fennelformat()
		local filepath = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
		filepath = filepath:gsub("%(", "\\(")
		filepath = filepath:gsub("%)", "\\)")
		return { exe = "fnlfmt --fix" }
	end
	local function _1_()
		return { args = { vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) }, exe = "google-java-format", stdin = true }
	end
	local function _2_()
		return {
			exe = ("cat " .. vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) .. " | black --quiet -"),
			stdin = true,
		}
	end
	local function _3_()
		return {
			exe = (
				"cat "
				.. vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
				.. " | sql-formatter -c "
				.. vim.fn.stdpath("config")
				.. "/sql-formatter.json"
			),
			stdin = true,
		}
	end
	local function _4_()
		return { args = { "--format", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) }, exe = "xmllint", stdin = true }
	end
	return formatter.setup({
		filetype = {
			arduino = { cformat },
			c = { cformat },
			clojure = { clojureformat },
			css = { prettier },
			elixir = { elixirformat },
			fennel = { fennelformat },
			gleam = { gleamformat },
			html = { prettier },
			java = { _1_ },
			javascript = { prettier },
			javascriptreact = { prettier },
			json = { prettier },
			jsonc = { prettier },
			less = { prettier },
			lua = { require("formatter.filetypes.lua").stylua },
			markdown = { prettier },
			ocaml = { ocamlformat },
			python = { _2_ },
			rust = { rustfmt },
			scss = { prettier },
			sh = { shfmt },
			sql = { _3_ },
			typescript = { prettier },
			typescriptreact = { prettier },
			vue = { prettier },
			xml = { _4_ },
			yaml = { prettier },
		},
		log_level = vim.log.levels.WARN,
		logging = false,
	})
else
	return nil
end
