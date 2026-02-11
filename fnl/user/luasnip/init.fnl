(local (has-luasnip ls) (pcall require :luasnip))

(when (not has-luasnip) (lua "return "))

(ls.config.set_config {:enable_autosnippets true
                       :history true
                       :updateevents "TextChanged,TextChangedI"})

(vim.keymap.set [:i :s] :<c-j>
                (fn [] (when (ls.expand_or_jumpable) (ls.expand_or_jump))))

(vim.keymap.set [:i :s] :<c-k>
                (fn []
                  (when (ls.jumpable (- 1)) (ls.jump (- 1)))))

(vim.keymap.set :i :<c-l>
                (fn [] (when (ls.choice_active) (ls.change_choice 1))))

(require :user.luasnip.snippets.gleam)

(require :user.luasnip.snippets.global)

(require :user.luasnip.snippets.typescript)

(require :user.luasnip.snippets.clojure)

