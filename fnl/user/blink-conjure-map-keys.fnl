;; Custom blink.cmp source that extracts keys from the last Conjure
;; evaluation result when it is a Clojure map.
;; Reads from conjure.eval.results (no extra REPL eval, so *1 is not mutated).
(local source {})

(fn source.new []
  (setmetatable {} {:__index source}))

(fn source.enabled [_self]
  (= vim.bo.filetype :clojure))

(fn get-last-result []
  (let [(ok eval) (pcall require :conjure.eval)]
    (when (and ok eval.results (> (length eval.results) 0))
      (. eval.results (length eval.results)))))

(fn extract-map-keys [result-str]
  "Extract keyword keys from a Clojure map string.
   Matches :simple, :namespaced/key, :kebab-case, :with.dots etc."
  (when (and result-str (result-str:match "^%s*[{#]"))
    (let [keys []]
      (each [kw (result-str:gmatch "[{,
]%s*(::?[%w%-%._%*!%?]+/?[%w%-%._%*!%?]*)")]
        (table.insert keys kw))
      keys)))

(fn source.get_completions [_self _ callback]
  (local items [])
  (local seen {})
  (local kind-keyword (. (require :blink.cmp.types) :CompletionItemKind
                         :Keyword))
  (local plain-text vim.lsp.protocol.InsertTextFormat.PlainText)
  (let [last-result (get-last-result)]
    (when last-result
      (let [keys (extract-map-keys last-result.result)]
        (when keys
          (each [_ key (ipairs keys)]
            (when (not (. seen key))
              (tset seen key true)
              (table.insert items
                            {:label key
                             :kind kind-keyword
                             :insertTextFormat plain-text
                             :insertText key
                             :detail "*1 map key"})))))))
  (callback {:is_incomplete_forward false
             :is_incomplete_backward false
             : items}))

source
