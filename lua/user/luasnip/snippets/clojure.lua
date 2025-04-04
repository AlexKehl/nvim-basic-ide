local ls = require("luasnip")

ls.add_snippets("clojure", {
	ls.s("defn", {
		ls.text_node("(defn "),
		ls.insert_node(1),
		ls.text_node(" ["),
		ls.insert_node(2),
		ls.text_node("] "),
		ls.insert_node(3),
		ls.text_node(")"),
	}),

	ls.s("def", {
		ls.text_node("(def "),
		ls.insert_node(1),
		ls.text_node(" "),
		ls.insert_node(2),
		ls.text_node(")"),
	}),

	ls.s("let", {
		ls.text_node("(let ["),
		ls.insert_node(1),
		ls.text_node("] "),
		ls.insert_node(2),
		ls.text_node(")"),
	}),

	ls.s("if", {
		ls.text_node("(if "),
		ls.insert_node(1),
		ls.text_node(" "),
		ls.insert_node(2),
		ls.text_node(" "),
		ls.insert_node(3),
		ls.text_node(")"),
	}),

	ls.s("fn", {
		ls.text_node("(fn ["),
		ls.insert_node(1),
		ls.text_node("] "),
		ls.insert_node(2),
		ls.text_node(")"),
	}),

	ls.s("->", {
		ls.text_node("(-> "),
		ls.insert_node(1),
		ls.text_node(" "),
		ls.insert_node(2),
		ls.text_node(")"),
	}),

	ls.s("->>", {
		ls.text_node("(->> "),
		ls.insert_node(1),
		ls.text_node(" "),
		ls.insert_node(2),
		ls.text_node(")"),
	}),

	ls.s("doseq", {
		ls.text_node("(doseq ["),
		ls.insert_node(1),
		ls.text_node("] "),
		ls.insert_node(2),
		ls.text_node(")"),
	}),

	ls.s("when", {
		ls.text_node("(when "),
		ls.insert_node(1),
		ls.text_node(" "),
		ls.insert_node(2),
		ls.text_node(")"),
	}),


	ls.s("(", {
    ls.text_node("("),
    ls.insert_node(1),
    ls.text_node(")"),
	}),
})
