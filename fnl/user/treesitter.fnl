(local configs (require :nvim-treesitter.configs))

(fn disabled? [_ buf]
  (let [max-filesize (* 50 1024)
        (ok stats) (pcall (vim.loop.fs_stat (vim.api.nvim_buf_get_name buf)))]
    (and ok (> (:size stats) max-filesize))))

(configs.setup {:ensure_installed [:tsx
                                   :lua
                                   :rust
                                   :typescript
                                   :javascript
                                   :clojure]
                :ignore_install [""]
                :rainbow {:enable true}
                :indent {:enable true :disable [:python :css]}
                ;; :context_commentstring {:enable true
                ;;                        :enable_autocmd false
                ;;                        :config {:typescript {:__default "// %s"
                ;;                                              :__multiline "/* %s */"}}}
                :highlight {:enable true
                            :disable disabled?
                            :custom_captures {:keyword.special :Special
                                              :namespace :Include}
                            :additional_vim_regex_highlighting false}
                :textobjects {:select {:enable true
                                       :lookahead true
                                       :keymaps {:aa "@parameter.outer"
                                                 :ia "@parameter.inner"
                                                 :af "@function.outer"
                                                 :if "@function.inner"
                                                 :id "@conditional.inner"
                                                 :ad "@conditional.outer"
                                                 :av "@assignment.outer"
                                                 :iv "@assignment.inner"
                                                 :ar "@return.outer"
                                                 :ir "@return.inner"}}
                              :move {:enable true
                                     :set_jumps true
                                     :goto_next_start {"]f" "@function.outer"
                                                       "]a" "@parameter.outer"
                                                       "]d" "@conditional.outer"
                                                       "]b" "@block.outer"}
                                     :goto_previous_start {"[f" "@function.outer"
                                                           "[a" "@parameter.outer"
                                                           "[d" "@conditional.outer"
                                                           "[b" "@block.outer"}}}})
