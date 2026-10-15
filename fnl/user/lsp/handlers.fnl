(local custom-references-picker
       (. (require :user.telescope) :custom_references_picker))

(local c (require :nfnl/core))
(local ts-utils (require :nvim-treesitter.ts_utils))

(local keymap vim.api.nvim_buf_set_keymap)
(local opts {:noremap true :silent true})

(local client-capabilities (vim.lsp.protocol.make_client_capabilities))

(set client-capabilities.textDocument.completion.completionItem.snippetSupport
     true)

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
                    (.. (vim.fn.stdpath :cache) "/" :my_log.txt) :a)
  message)

(fn get-parent-type [node]
  (if (node:parent) (get-parent-type (node:parent) (node:type))))

(fn is-import-statement [node]
  (when (not (c.nil? node))
    (vim.inspect (vim.print (node:type))))
  (if (c.nil? node) false
      (or (= (node:type) :import_statement) (= (node:type) :import_declaration)
          (= (node:type) :import_clause) (= (node:type) :import_specifier)
          (= (node:type) :named_imports)) true
      (is-import-statement (node:parent))))

(fn is-export-statement [node]
  (if (c.nil? node) false
      (= (node:type) :export_clause) true
      (is-export-statement (node:parent))))

(fn is-jsx-closing-tag [node]
  (if (c.nil? node) false
      (= (node:type) :jsx_closing_element) true
      (is-jsx-closing-tag (node:parent))))

(fn is-test-file [filename]
  (or (string.find filename :test.ts) (string.find filename :test.clj)))

(fn is-current-node [buf node]
  (if (not= buf (vim.fn.bufnr))
      false
      (= (node:start) (: (ts-utils.get_node_at_cursor) :start))))

(fn relevant-reference? [buf reference]
  (when (= 0 (vim.fn.bufloaded buf)) (vim.fn.bufload buf))
  (let [parser (vim.treesitter.get_parser buf)
        range [(. reference :user_data :range :start :line)
               (. reference :user_data :range :start :character)]
        _ (parser:parse range)
        node (vim.treesitter.get_node {:bufnr buf :pos range})]
    (not (or (is-current-node buf node) (is-import-statement node)
             (is-jsx-closing-tag node) (is-export-statement node)))))

(fn filter-relevant-references [references]
  (c.filter (fn [reference]
              (let [escaped-path (vim.uri_to_fname reference.user_data.uri)
                    buf (vim.fn.bufnr escaped-path)]
                (if (= buf -1) false
                    (is-test-file escaped-path) false
                    (relevant-reference? buf reference))))
            references))

(fn on-references [options]
  (local filtered-references (filter-relevant-references options.items))
  (when (= (length filtered-references) 0)
    (vim.print "No references found")
    (lua "return "))
  (when (= (length filtered-references) 1)
    (local reference (. filtered-references 1))
    (vim.lsp.util.show_document {:range reference.user_data.range
                                 :uri reference.user_data.uri}
                                :utf-8)
    (lua "return "))
  (set options.items filtered-references)
  (custom-references-picker filtered-references))

(fn test-reference-pred [reference]
  (let [escaped-path (vim.uri_to_fname reference.user_data.uri)
        buf (vim.fn.bufnr escaped-path)]
    (if (= buf -1) false
        (if (string.find escaped-path :test) true false))))

(fn filter-test-references [references]
  (c.filter test-reference-pred references))

(fn on-test-list [options]
  (local filtered-references (filter-test-references options.items))
  (when (= (length filtered-references) 0)
    (vim.print "No references found")
    (lua "return "))
  (local reference (. filtered-references 1))
  (vim.lsp.util.show_document {:range reference.user_data.range
                               :uri reference.user_data.uri}
                              :utf-8))

(fn code-action-filter [code-action]
  (if (or (string.find code-action.title :Add)
          (string.find code-action.title :Update))
      true
      false))

(fn get-lsp-client [name]
  (local clients (vim.lsp.get_clients {: name}))
  (. clients 1))

(fn organize-imports []
  (vim.lsp.buf.code_action {:apply true
                            :context {:only [:source.organizeImports]}}))

(fn add-missing-imports []
  (vim.lsp.buf.code_action {:apply true
                            :filter (fn [a]
                                      (= a.title "Add all missing imports"))}))

(fn apply-eslint-fixes [bufnr]
  (local client (get-lsp-client :tsc))
  (client:exec_cmd {:command :eslint.applyAllFixes
                    :arguments [{:uri (vim.uri_from_bufnr bufnr)
                                 :version (. vim.lsp.util.buf_versions bufnr)}]
                    :title ""}))

(fn ts-custom-commands [bufnr]
  (local client (get-lsp-client :tsc))
  (log (vim.inspect client))
  (vim.api.nvim_buf_create_user_command bufnr :OrganizeImports organize-imports
                                        {})
  (vim.api.nvim_buf_create_user_command bufnr :AddMissingImports
                                        add-missing-imports {}))

(fn eslint-custom-commands [bufnr]
  (vim.api.nvim_buf_create_user_command bufnr :EslintFixAll
                                        (fn [] (apply-eslint-fixes bufnr)) {}))

(fn get-cursor-coords [bufnr]
  (local uri (vim.uri_from_bufnr bufnr))
  (local row (- (. (vim.fn.getpos ".") 2) 1))
  (local col (- (. (vim.fn.getpos ".") 3) 1))
  [uri row col])

(fn clojure-custom-commands [bufnr]
  (local client (get-lsp-client :clojure_lsp))
  (vim.api.nvim_buf_create_user_command bufnr :CleanNs
                                        (fn []
                                          (client:exec_cmd {:command :clean-ns
                                                            :arguments (get-cursor-coords bufnr)}))
                                        {})
  (vim.api.nvim_buf_create_user_command bufnr :AddMissingLibspec
                                        (fn []
                                          (client:exec_cmd {:command :add-missing-libspec
                                                            :arguments (get-cursor-coords bufnr)}))
                                        {})
  (vim.api.nvim_buf_create_user_command bufnr :DragBackward
                                        (fn []
                                          (client:exec_cmd {:command :drag-backward
                                                            :arguments (get-cursor-coords bufnr)}))
                                        {})
  (vim.api.nvim_buf_create_user_command bufnr :DragForward
                                        (fn []
                                          (client:exec_cmd {:command :drag-forward
                                                            :arguments (get-cursor-coords bufnr)}))
                                        {})
  (vim.api.nvim_buf_create_user_command bufnr :IntroduceLet
                                        (fn []
                                          (client:exec_cmd {:command :introduce-let
                                                            :arguments (c.concat (get-cursor-coords bufnr)
                                                                                 [:tmp-name])}))
                                        {})
  (keymap bufnr :n :<leader>cn ":CleanNs<CR>" opts)
  (keymap bufnr :n "<" ":DragBackward<CR>" opts)
  (keymap bufnr :n ">" ":DragForward<CR>" opts)
  (keymap bufnr :n :<leader>ml ":IntroduceLet<CR>" opts))

(fn lsp-keymaps [bufnr]
  (keymap bufnr :n :gD "<cmd>lua vim.lsp.buf.declaration()<CR>" opts)
  (keymap bufnr :n :gy ":Telescope lsp_type_definitions show_line=false<CR>"
          opts)
  (keymap bufnr :n :gd ":Telescope lsp_definitions show_line=false<CR>" opts)
  (keymap bufnr :n :K "<cmd>lua vim.lsp.buf.hover()<CR>" opts)
  (keymap bufnr :n :gi ":Telescope lsp_implementations show_line=false<CR>"
          opts)
  (vim.keymap.set :n :gr
                  (fn []
                    (vim.lsp.buf.references nil {:on_list on-references}))
                  opts)
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
  (vim.keymap.set :n :gt
                  (fn [] (vim.lsp.buf.references nil {:on_list on-test-list}))
                  opts))

(fn log [message]
  (vim.fn.writefile [(vim.inspect message)]
                    (.. (vim.fn.stdpath :cache) :/my_log.txt) :a)
  message)

(fn on_attach [client bufnr]
  (when (= client.name :tsc)
    (set client.server_capabilities.document_formatting false)
    (ts-custom-commands bufnr))
  (when (= client.name :sumneko_lua)
    (set client.server_capabilities.document_formatting false))
  (when (= client.name :gleam)
    (set client.server_capabilities.documentFormattingProvider true))
  (when (= client.name :eslint)
    (eslint-custom-commands bufnr))
  (when (= client.name :clojure_lsp)
    (clojure-custom-commands bufnr))
  (lsp-keymaps bufnr))

; (local lspconfig (require :lspconfig))

; (lspconfig.gleam.setup {: capabilities
;                         :cmd [:gleam :lsp]
;                         :filetypes [:gleam]
;                         : on_attach
;                         :root_dir (lspconfig.util.root_pattern :gleam.toml
;                                                                :.git)})

; (lspconfig.fennel_ls.setup {: on_attach})

(vim.lsp.enable :tsc)
(vim.lsp.config :tsc {: on_attach})

(vim.lsp.enable :clojure_lsp)
(vim.lsp.config :clojure_lsp {: on_attach})

(vim.lsp.enable :marksman)
(vim.lsp.config :marksman {: on_attach})

(vim.lsp.enable :eslint)
(vim.lsp.config :eslint {: on_attach})

(vim.lsp.enable :fennel_ls)
(vim.lsp.config :fennel_ls {: on_attach})

{: on_attach : setup}
