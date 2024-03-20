local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local compare = require("cmp.config.compare")
local types = require("cmp.types")

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

-- require("luasnip/loaders/from_vscode").lazy_load()

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
	-- icons for vim-dadbod-completion
	SQL = "",
}

local lsp_priority = {
	["Function"] = 5,
	["Method"] = 6,
	-- add more if needed
}

local priority_sort = function(entry1, entry2)
	local item1 = entry1:get_completion_item()
	local item2 = entry2:get_completion_item()

	local p1 = lsp_priority[item1.kind] or 0
	local p2 = lsp_priority[item2.kind] or 0

	if p1 ~= p2 then
		return p1 > p2
	end

	return compare.offset(entry1, entry2) or compare.order(entry1, entry2)
end

local function log(msg)
	local logFile = "/Users/alexanderkehl/nvim.log"
	local file = io.open(logFile, "a")
	if file then
		file:write(msg .. "\n")
		file:flush()
		file:close()
	else
		error("Cannot open log file: " .. logFile)
	end
end

local function tableToString(tbl, indent)
	if not indent then
		indent = 0
	end
	if type(tbl) ~= "table" then
		return tostring(tbl)
	end
	local str = ""
	local padding = string.rep(" ", indent)
	str = str .. "{\n"
	for k, v in pairs(tbl) do
		local key = tostring(k)
		str = str .. padding .. "  [" .. key .. "] = "
		if type(v) == "table" then
			str = str .. tableToString(v, indent + 4) .. ",\n"
		else
			str = str .. tostring(v) .. ",\n"
		end
	end
	str = str .. padding .. "}"
	return str
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},

	mapping = cmp.mapping.preset.insert({
		-- ["<C-k>"] = cmp.mapping.select_prev_item(),
		-- ["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-e>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		-- ["<C-e>"] = cmp.mapping({
		-- 	i = cmp.mapping.abort(),
		-- 	c = cmp.mapping.close(),
		-- }),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
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
		-- format = function(entry, vim_item)
		-- 	-- This concats the icons with the label of the item kind
		-- 	vim_item.kind = string.format("%s %s %s", kind_icons[vim_item.kind], vim_item.kind, vim_item.menu)
		-- 	return vim_item
		-- end,
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
				-- path = "",
				-- emoji = "",
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
	-- sorting = {
	-- 	comparators = {
	-- 		-- compare.offset,
	-- 		-- compare.exact,
	-- 		compare.score,
	-- 		-- compare.recently_used,
	-- 		-- compare.locality,
	-- 		-- compare.kind,
	-- 		-- compare.sort_text,
	-- 		-- compare.length,
	-- 		-- compare.order,
	-- 	},
	-- },
	-- sorting = {
	-- 	-- priority_weight = 1.0,
	-- 	comparators = {
	-- 		priority_sort,
	-- 		-- compare.score_offset, -- not good at all
	--
	-- 		-- cmp.config.compare.locality,
	-- 		-- cmp.config.compare.recently_used,
	-- 		-- cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
	-- 		-- cmp.config.compare.offset,
	-- 		-- cmp.config.compare.order,
	--
	-- 		-- compare.sort_text,
	-- 		-- compare.exact,
	-- 		-- compare.kind,
	-- 	},
	-- },
})
