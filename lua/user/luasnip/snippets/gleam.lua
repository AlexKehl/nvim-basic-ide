-- [nfnl] fnl/user/luasnip/snippets/gleam.fnl
local ls = require("luasnip")
return ls.add_snippets("gleam", {ls.s("fn", {ls.text_node("fn("), ls.insert_node(1), ls.text_node(") {"), ls.insert_node(0), ls.text_node("}")})})
