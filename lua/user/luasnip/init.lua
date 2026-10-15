local has_luasnip, ls = pcall(require, "luasnip")
if not has_luasnip then
	return
end
ls.config.set_config({ enable_autosnippets = true, history = true, updateevents = "TextChanged,TextChangedI" })
local function _2_()
	if ls.expand_or_jumpable() then
		return ls.expand_or_jump()
	else
		return nil
	end
end
vim.keymap.set({ "i", "s" }, "<c-j>", _2_)
local function _4_()
	if ls.jumpable(-1) then
		return ls.jump(-1)
	else
		return nil
	end
end
vim.keymap.set({ "i", "s" }, "<c-k>", _4_)
local function _6_()
	if ls.choice_active() then
		return ls.change_choice(1)
	else
		return nil
	end
end
vim.keymap.set("i", "<c-l>", _6_)
require("user.luasnip.snippets.gleam")
require("user.luasnip.snippets.global")
require("user.luasnip.snippets.typescript")
return require("user.luasnip.snippets.clojure")
