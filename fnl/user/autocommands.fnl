(local keymap-opts {:buffer true :noremap true :silent true})

(vim.api.nvim_create_autocmd :FileType
                             {:callback (fn []
                                          (vim.keymap.set :n :<leader>or
                                                          :<cmd>OrganizeImports<CR>
                                                          keymap-opts)
                                          (vim.keymap.set :n :<leader>oi
                                                          :<cmd>AddMissingImports<CR>
                                                          keymap-opts))
                              :pattern [:typescript :typescriptreact]})

(vim.api.nvim_create_autocmd :FileType
                             {:callback (fn []
                                          (vim.keymap.set :n :<leader>or
                                                          :<cmd>OrganizeImports<CR>
                                                          keymap-opts))
                              :pattern [:typescript :typescriptreact]})

(vim.api.nvim_create_autocmd :BufEnter
                             {:command "syntax sync fromstart"
                              :pattern [:*.ly :*.ily :*.tex]})
