local ls = require("luasnip")

ls.add_snippets("all", {
	ls.s("clo", {
		ls.text_node("console.log"),
	}),
	ls.s("arr", {
		ls.text_node("() => "),
	}),
})
