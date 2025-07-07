(local keymap-opts {:buffer true :noremap true :silent true})

(vim.api.nvim_create_autocmd :FileType
                             {:callback (fn []
                                          (vim.keymap.set :n :<leader>or
                                                          :<cmd>OrganizeImports<CR>
                                                          keymap-opts))
                              :pattern [:typescript :typescriptreact]})

(vim.api.nvim_create_autocmd :FileType
                             {:callback (fn []
                                          ((. (require :csvview) :enable))
                                          (vim.opt_local.formatoptions:remove :t))
                              :desc "Enable CSV View on .csv files"
                              :pattern [:csv :tsv]})

(vim.api.nvim_create_autocmd :FileType
                             {:callback (fn []
                                          (vim.keymap.set :n :<Tab>
                                                          :<cmd>ParinferToggle<CR>
                                                          keymap-opts))
                              :pattern [:clojure :scheme :lisp :racket :fennel]})

(vim.api.nvim_create_autocmd :BufEnter
                             {:callback (fn []
                                          (if (not= vim.bo.filetype :qf)
                                              (vim.keymap.set :n :<CR>
                                                              (fn []
                                                                (vim.cmd :FormatWrite))
                                                              opts)
                                              (vim.keymap.del :n :<CR>)))})
