(fn log [val]
  (print (vim.inspect val))
  val)

(fn path->filename [path]
  (let [splitted (vim.split path "/")
        last (. splitted (length splitted))
        [filename ext] (vim.split last "%.")]
    {: filename : ext}))

(fn get-clojure-path [buf-path]
  (let [{: filename : ext} (path->filename buf-path)]
    (if (string.match buf-path :src/)
        (-> buf-path (string.gsub :src/ :test/)
            (string.gsub (.. filename "." ext) (.. filename :_test. ext)))
        (string.match buf-path :test/)
        (-> buf-path (string.gsub :test/ :src/)
            (string.gsub filename (string.gsub filename :_test "")))
        :else
        (print "Could not match file"))))

(fn get-ts-path [buf-path]
  (let [filename (path->filename buf-path)]
    (if (vim.endswith buf-path :.test.ts)
        (string.gsub buf-path (.. filename :.test.ts) (.. filename :.ts))
        (vim.endswith buf-path :.ts)
        (string.gsub buf-path (.. filename :.ts) (.. filename :.test.ts))
        :else
        (print "Could not match file"))))

(fn get-alternate-file []
  (let [buf-path (vim.api.nvim_buf_get_name (vim.api.nvim_get_current_buf))
        ft vim.bo.filetype]
    (case ft
      :clojure (get-clojure-path buf-path)
      :fennel (get-clojure-path buf-path)
      :typescript (get-ts-path ft)
      :javascript (get-ts-path ft))))

(fn open-projection []
  (vim.api.nvim_command (.. "edit " (get-alternate-file))))

(fn refresh []
  (let [projectionist (require :user.projectionist)]
    (projectionist.setup))
  (vim.api.nvim_command :write))

(fn setup []
  (vim.keymap.set :n :<leader>ej "<cmd>ConjureEval (refresh)<CR>")
  (vim.keymap.set :n :<leader>a open-projection))

{: setup}
