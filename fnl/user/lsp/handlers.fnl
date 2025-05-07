(local custom-references-picker
       (. (require :user.telescope) :custom_references_picker))

(local c (require :nfnl/core))
(local ts-utils (require :nvim-treesitter.ts_utils))

(local (status-cmp-ok cmp-nvim-lsp) (pcall require :cmp_nvim_lsp))

(when (not status-cmp-ok) (lua "return "))

(local client-capabilities (vim.lsp.protocol.make_client_capabilities))

(set client-capabilities.textDocument.completion.completionItem.snippetSupport
     true)

(local capabilities (cmp-nvim-lsp.default_capabilities client-capabilities))

(fn setup []
  (vim.diagnostic.config {:float {:border :rounded
                                  :focusable true
                                  :header ""
                                  :prefix ""
                                  :source :always
                                  :style :minimal}
                          :severity_sort true
                          :signs {:text {vim.diagnostic.severity.ERROR ""
                                         vim.diagnostic.severity.HINT "󰌵"
                                         vim.diagnostic.severity.INFO ""
                                         vim.diagnostic.severity.WARN ""}}
                          :underline false
                          :update_in_insert true
                          :virtual_text false})
  (set vim.lsp.handlers.textDocument/hover
       (vim.lsp.with vim.lsp.handlers.hover {:border :rounded}))
  (set vim.lsp.handlers.textDocument/signatureHelp
       (vim.lsp.with vim.lsp.handlers.signature_help {:border :rounded})))

(fn log [message]
  (vim.fn.writefile [(vim.inspect message)]
                    (.. (vim.fn.stdpath :cache) :/my_log.txt) :a)
  message)

(fn get-parent-type [node]
  (if (node:parent) (get-parent-type (node:parent) (node:type))))

(fn is-import-statement [node]
  (if (c.nil? node) false
      (or (= (node:type) :import_statement) (= (node:type) :import_declaration)
          (= (node:type) :import_clause) (= (node:type) :import_specifier)
          (= (node:type) :named_imports)) true
      (is-import-statement (node:parent))))

(vim.keymap.set :n :<leader>fp
                (fn []
                  (get-parent-type (ts-utils.get_node_at_cursor))))

(fn is-current-node [buf node]
  (if (not= buf (vim.fn.bufnr))
      false
      (= (node:start) (: (ts-utils.get_node_at_cursor) :start))))

(fn check-reference [buf reference]
  (vim.fn.bufload buf)
  (let [parser (vim.treesitter.get_parser buf)
        range [(. reference :user_data :range :start :line)
               (. reference :user_data :range :start :character)]
        _ (: parser :parse range)
        node (vim.treesitter.get_node {:bufnr buf :pos range})]
    (not (or (is-current-node buf node) (is-import-statement node)))))

(fn filter-references-with-treesitter [references]
  (c.filter (fn [reference]
              (let [escaped-path (vim.uri_to_fname reference.user_data.uri)
                    buf (vim.fn.bufnr escaped-path)]
                (if (= buf -1) false
                    (check-reference buf reference)))) references))

(fn custom-lsp-references-with-treesitter []
  (vim.lsp.buf.references nil
                          {:on_list (fn [options]
                                      (local filtered-references
                                             (filter-references-with-treesitter options.items))
                                      (when (= (length filtered-references) 0)
                                        (vim.print "No references found")
                                        (lua "return "))
                                      (when (= (length filtered-references) 1)
                                        (local reference
                                               (. filtered-references 1))
                                        (vim.lsp.util.show_document {:range reference.user_data.range
                                                                     :uri reference.user_data.uri}
                                                                    :utf-8)
                                        (lua "return "))
                                      (set options.items filtered-references)
                                      (custom-references-picker filtered-references))}))

(fn test-reference-pred [reference]
  (let [escaped-path (vim.uri_to_fname reference.user_data.uri)
        buf (vim.fn.bufnr escaped-path)]
    (if (= buf -1) false
        (if (string.find escaped-path :test) true false))))

(fn filter-test-references [references]
  (c.filter test-reference-pred references))

(fn go-to-test []
  (vim.lsp.buf.references nil {:on_list (fn [options]
                                          (local filtered-references
                                                 (filter-test-references options.items))
                                          (when (= (length filtered-references)
                                                   0)
                                            (vim.print "No references found")
                                            (lua "return "))
                                          (local reference
                                                 (. filtered-references 1))
                                          (vim.lsp.util.show_document {:range reference.user_data.range
                                                                       :uri reference.user_data.uri}
                                                                      :utf-8)
                                          nil)}))

(fn code-action-filter [code-action]
  (if (or (string.find code-action.command.title :Add)
          (string.find code-action.command.title :Update))
      true
      false))

(local keymap vim.api.nvim_buf_set_keymap)
(local opts {:noremap true :silent true})

(fn lsp-keymaps [bufnr]
  (keymap bufnr :n :gD "<cmd>lua vim.lsp.buf.declaration()<CR>" opts)
  (keymap bufnr :n :gy ":Telescope lsp_type_definitions show_line=false<CR>"
          opts)
  (keymap bufnr :n :gd ":Telescope lsp_definitions show_line=false<CR>" opts)
  (keymap bufnr :n :K "<cmd>lua vim.lsp.buf.hover()<CR>" opts)
  (keymap bufnr :n :gi ":Telescope lsp_implementations show_line=false<CR>"
          opts)
  (vim.keymap.set :n :gr custom-lsp-references-with-treesitter opts)
  (keymap bufnr :n :gl "<cmd>lua vim.diagnostic.open_float()<CR>" opts)
  (vim.keymap.set :n :<leader>f
                  (fn []
                    (if (or (= vim.bo.filetype :typescript)
                            (= vim.bo.filetype :typescriptreact))
                        (vim.lsp.buf.code_action {:filter code-action-filter})
                        (vim.lsp.buf.code_action))) opts)
  (keymap bufnr :n :<leader>F "<cmd>lua vim.lsp.buf.code_action()<cr>" opts)
  (keymap bufnr :n "]g" "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>"
          opts)
  (keymap bufnr :n "[g" "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>"
          opts)
  (keymap bufnr :n :<leader>rn "<cmd>lua vim.lsp.buf.rename()<cr>" opts)
  (vim.keymap.set :n :gt go-to-test opts))

(fn on_attach [client bufnr]
  (when (= client.name :ts_ls)
    (set client.server_capabilities.document_formatting false))
  (when (= client.name :sumneko_lua)
    (set client.server_capabilities.document_formatting false))
  (when (= client.name :gleam)
    (set client.server_capabilities.documentFormattingProvider true))
  (lsp-keymaps bufnr))

(local (lspconfig-status-ok lspconfig) (pcall require :lspconfig))

(when (not lspconfig-status-ok) (lua "return "))

(lspconfig.gleam.setup {: capabilities
                        :cmd [:gleam :lsp]
                        :filetypes [:gleam]
                        : on_attach
                        :root_dir (lspconfig.util.root_pattern :gleam.toml
                                                               :.git)})

(lspconfig.fennel_ls.setup {})

{: on_attach : setup}
