local has_luasnip, ls = pcall(require, "luasnip")
if not has_luasnip then
	return
end

ls.config.set_config({
	-- This tells LuaSnip to keep around the last snippet.
	-- You can jump back into it even if you move outside of the selection.
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
	-- ext_opts = {
	-- 	[types.choiceNode] = {
	-- 		active = {
	-- 			virt_text = { { "<-", "Error" } },
	-- 		},
	-- 	},
	-- },
})
vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end)

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end)

vim.keymap.set("i", "<c-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)

-- vim.keymap.set("n", ",,s", "<cmd>source ~/.config/nvim/lua/configs/luasnip.lua<CR>")

local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local t = ls.text_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local function capitalize(args)
	local str = args[1][1]
	if str:len() == 1 then
		return str:upper()
	end
	return str:sub(1, 1):upper() .. str:sub(2)
end

ls.add_snippets("all", {
	s("clo", {
		t("console.log"),
	}),
	s("arr", {
		t("() => "),
	}),
})


ls.add_snippets("gleam", {
	ls.s("fn", {
		ls.text_node("fn("),
    ls.insert_node(1),
    ls.text_node(") {"),
    ls.insert_node(0),
    ls.text_node("}"),
	}),
})

ls.add_snippets("typescript", {
	s("exp", {
		t('export * from "./'),
		i(1),
		t('";', "path to component"),
		i(0),
	}),

	s("ex", {
		t("export {"),
		i(0),
		t('} from "./'),
		i(1),
		t('"'),
	}),

	s("describe", {
		t("describe("),
		i(1),
		t(", () => {"),
		t({ "", "" }),
		t({ "\tit(" }),
		i(2),
		t(", () => {", "\t"),
		t({ "", "" }),
		t({ "\t});", "});" }),
	}),

	s("it", {
		t({ "it(" }),
		i(1),
		t(", () => {", "\t"),
		t({ "", "" }),
		t({ "});" }),
	}),
})

ls.add_snippets("typescriptreact", {
	s("rfc", {
		t({ "", "export const " }),
		i(1, "FunctionName"),
		t({ " = () => {", "\t" }),
		t({ "return (" }),
		t({ "<>" }),
		t({ "Component" }),
		t({ "</>" }),
		t({ ");", "}" }),
	}),
})
