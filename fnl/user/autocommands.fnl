(local keymap-opts {:buffer true :noremap true :silent true})

(vim.api.nvim_create_autocmd :FileType
                             {:callback (fn []
                                          (vim.keymap.set :n :<leader>or
                                                          :<cmd>OrganizeImports<CR>
                                                          keymap-opts))
                              :pattern [:typescript :typescriptreact]})

; (vim.api.nvim_create_autocmd :BufEnter
;                              {:callback (fn []
;                                           (if (or (= vim.bo.filetype :qf)
;                                                   (= ":" (vim.fn.getcmdwintype)))
;                                               (pcall vim.keymap.del :n :<CR>)
;                                               (vim.keymap.set :n :<CR>
;                                                               (fn []
;                                                                 (vim.cmd :FormatWrite)))))})

(vim.api.nvim_create_autocmd :BufEnter
                             {:callback (fn []
                                          (if (not= vim.bo.filetype :qf)
                                              (vim.keymap.set :n :<CR>
                                                              (fn []
                                                                (vim.cmd :FormatWrite))
                                                              opts)
                                              (vim.keymap.del :n :<CR>)))})


(vim.api.nvim_create_autocmd :BufEnter
                             {:command "syntax sync fromstart"
                              :pattern ["*.ly" "*.ily" "*.tex"]})
