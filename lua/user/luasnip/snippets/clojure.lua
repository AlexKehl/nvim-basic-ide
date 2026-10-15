local ls = require("luasnip")
return ls.add_snippets(
	"clojure",
	{
		ls.s(
			"defn",
			{
				ls.text_node("(defn "),
				ls.insert_node(1),
				ls.text_node(" ["),
				ls.insert_node(2),
				ls.text_node("] "),
				ls.insert_node(3),
				ls.text_node(")"),
			}
		),
		ls.s(
			"let",
			{ ls.text_node("(let ["), ls.insert_node(1), ls.text_node("] "), ls.insert_node(2), ls.text_node(")") }
		),
		ls.s(
			"fn",
			{ ls.text_node("(fn ["), ls.insert_node(1), ls.text_node("] "), ls.insert_node(2), ls.text_node(")") }
		),
		ls.s("co", { ls.text_node("(comment "), ls.insert_node(1), ls.text_node(")") }),
	}
)
