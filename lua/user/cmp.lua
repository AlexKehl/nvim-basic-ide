return function()
	local cmp_status_ok, cmp = pcall(require, "cmp")
	if not cmp_status_ok then
		return
	end

	local snip_status_ok, luasnip = pcall(require, "luasnip")
	if not snip_status_ok then
		return
	end

	local check_backspace = function()
		local col = vim.fn.col(".") - 1
		return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
	end

	local kind_icons = {
		Text = "",
		Method = "",
		Function = "",
		Constructor = "",
		Field = "",
		Variable = "",
		Class = "",
		Interface = "",
		Module = "",
		Property = "",
		Unit = "",
		Value = "",
		Enum = "",
		Keyword = "",
		Snippet = "",
		Color = "",
		File = "",
		Reference = "",
		Folder = "",
		EnumMember = "",
		Constant = "",
		Struct = "",
		Event = "",
		Operator = "",
		TypeParameter = "",
		SQL = "",
	}

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body) -- For `luasnip` users.
			end,
		},

		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
			["<C-e>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expandable() then
					luasnip.expand()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif check_backspace() then
					fallback()
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
		}),
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				if vim_item.menu == "[DB]" then
					vim_item.kind = kind_icons["SQL"]
				else
					vim_item.kind = kind_icons[vim_item.kind]
				end

				vim_item.menu = ({
					nvim_lsp = "",
					nvim_lua = "",
					luasnip = "",
					buffer = "",
					vim_dadbod_completion = "",
				})[entry.source.name]
				vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
				return vim_item
			end,
		},
		sources = {
			{ name = "nvim_lsp", priority = 1000 },
			{ name = "nvim_lua", priority = 1000 },
			{
				name = "buffer",
				option = {
					get_bufnrs = function()
						return vim.api.nvim_list_bufs()
					end,
				},
				priority = 500,
			},
			{ name = "path", priority = 250 },
			{ name = "luasnip", priority = 400 },
			{ name = "vim-dadbod-completion", priority = 700 },
		},
		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		experimental = {
			ghost_text = false,
		},
	})
end
