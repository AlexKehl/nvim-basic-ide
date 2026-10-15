local ls = require("luasnip")
ls.add_snippets(
	"typescript",
	{
		ls.s(
			"exp",
			{
				ls.text_node('export * from "./'),
				ls.insert_node(1),
				ls.text_node('";', "path to component"),
				ls.insert_node(0),
			}
		),
		ls.s(
			"ex",
			{
				ls.text_node("export {"),
				ls.insert_node(0),
				ls.text_node('} from "./'),
				ls.insert_node(1),
				ls.text_node('"'),
			}
		),
		ls.s(
			"describe",
			{
				ls.text_node("describe("),
				ls.insert_node(1),
				ls.text_node(", () => {"),
				ls.text_node({ "", "" }),
				ls.text_node({ "\9it(" }),
				ls.insert_node(2),
				ls.text_node(", () => {", "\9"),
				ls.text_node({ "", "" }),
				ls.text_node({ "\9});", "});" }),
			}
		),
		ls.s(
			"it",
			{
				ls.text_node({ "it(" }),
				ls.insert_node(1),
				ls.text_node(", () => {", "\9"),
				ls.text_node({ "", "" }),
				ls.text_node({ "});" }),
			}
		),
	}
)
ls.add_snippets(
	"typescriptreact",
	{
		ls.s(
			"fc",
			{
				ls.text_node({ "", "export function " }),
				ls.insert_node(1, "FunctionName"),
				ls.text_node({ "() {", "\9" }),
				ls.text_node({ "return Component" }),
				ls.text_node({ ");", "}" }),
			}
		),
	}
)
return ls.add_snippets("typescriptreact", { ls.s("dis", { ls.text_node({ "const dispatch = useDispatch()" }) }) })
