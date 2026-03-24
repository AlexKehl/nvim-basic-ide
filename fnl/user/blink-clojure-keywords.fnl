;; Custom blink.cmp source that extracts Clojure namespaced keywords (e.g. :ns/name)
;; from open buffers. The built-in buffer source splits on '/' so it can't handle these.
(local source {})

(fn source.new []
  (setmetatable {} {:__index source}))

(fn source.enabled [_self]
  (= vim.bo.filetype :clojure))

(fn source.get_completions [_self _ callback]
  (local items [])
  (local seen {})
  (local kind-text (. (require :blink.cmp.types) :CompletionItemKind :Text))
  (local plain-text vim.lsp.protocol.InsertTextFormat.PlainText)
  (each [_ bufnr (ipairs (vim.api.nvim_list_bufs))]
    (when (vim.api.nvim_buf_is_loaded bufnr)
      (each [_ line (ipairs (vim.api.nvim_buf_get_lines bufnr 0 -1 false))]
        ;; Match optional leading colon, namespace, slash, name
        ;; e.g. :Listing/maxPetsAllowed or Listing/maxPetsAllowed
        (each [word (line:gmatch ":?[%w%-%._]+/[%w%-%._]+")]
          (when (not (. seen word))
            (tset seen word true)
            (table.insert items
                          {:label word
                           :kind kind-text
                           :insertTextFormat plain-text
                           :insertText word}))))))
  (callback {:is_incomplete_forward false
             :is_incomplete_backward false
             : items}))

source
