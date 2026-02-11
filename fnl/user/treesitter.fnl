(local configs (require :nvim-treesitter.configs))

(fn disabled? [_ buf]
  (let [max-filesize (* 50 1024)
        (ok stats) (pcall (vim.loop.fs_stat (vim.api.nvim_buf_get_name buf)))]
    (and ok (> (:size stats) max-filesize))))

;; Custom expand/shrink functions for visual mode
;; Uses treesitter incremental selection but only triggers in visual mode
(fn expand-selection []
  (let [ts-sel (require :nvim-treesitter.incremental_selection)]
    (if vim.b.ts_current_node
        (ts-sel.init_selection)
        (ts-sel.node_incremental))))

(fn shrink-selection []
  (let [ts-sel (require :nvim-treesitter.incremental_selection)]
    (ts-sel.node_decremental)))

(vim.keymap.set :v :v expand-selection {:noremap true})
(vim.keymap.set :v :<C-v> shrink-selection {:noremap true})

(configs.setup {:ensure_installed [:tsx
                                   :lua
                                   :rust
                                   :typescript
                                   :javascript
                                   :clojure]
                :ignore_install [""]
                :rainbow {:enable true}
                :incremental_selection {:enable true
                                        :keymaps {:init_selection false
                                                  :node_incremental false
                                                  :node_decremental false
                                                  :scope_incremental false}}
                :indent {:enable true :disable [:python :css]}
                ;; :context_commentstring {:enable true
                ;;                        :enable_autocmd false
                ;;                        :config {:typescript {:__default "// %s"
                ;;                                              :__multiline "/* %s */"}}}
                :highlight {:enable true
                            :disable disabled?
                            :custom_captures {:keyword.special :Special
                                              :namespace :Include}
                            :additional_vim_regex_highlighting [:lilypond]}
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
