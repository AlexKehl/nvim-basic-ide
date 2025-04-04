local has_luasnip, ls = pcall(require, "luasnip")
if not has_luasnip then
	return
end

ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
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

require("user.luasnip.snippets.gleam")
require("user.luasnip.snippets.global")
require("user.luasnip.snippets.typescript")
require("user.luasnip.snippets.clojure")
