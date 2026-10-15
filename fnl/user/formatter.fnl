(local (present formatter) (pcall require :formatter))

(when present
  (fn prettier []
    (var filepath (vim.fn.fnameescape (vim.api.nvim_buf_get_name 0)))
    (set filepath (filepath:gsub "%(" "\\("))
    (set filepath (filepath:gsub "%)" "\\)"))
    {:args [filepath] :exe (.. "cat " filepath " | prettierd ") :stdin true})

  (fn rustfmt [] {:exe :rustfmt :stdin true})

  (fn ocamlformat []
    {:args [:--enable-outside-detected-project
            (vim.fn.fnameescape (vim.api.nvim_buf_get_name 0))]
     :exe :ocamlformat
     :stdin true})

  (fn elixirformat []
    (var filepath (vim.fn.fnameescape (vim.api.nvim_buf_get_name 0)))
    (set filepath (filepath:gsub "%(" "\\("))
    (set filepath (filepath:gsub "%)" "\\)"))
    {:exe (.. "cat " filepath " | mix format -") :stdin true})

  (fn gleamformat []
    (var filepath (vim.fn.fnameescape (vim.api.nvim_buf_get_name 0)))
    (set filepath (filepath:gsub "%(" "\\("))
    (set filepath (filepath:gsub "%)" "\\)"))
    {:exe "gleam format"})

  (fn lspformat [] (vim.lsp.buf.format))

  (fn shfmt [] {:args [:-i :2 :-ci :-s] :exe :shfmt :stdin true})

  (fn cformat []
    {:args [(vim.fn.fnameescape (vim.api.nvim_buf_get_name 0))]
     :exe :clang-format
     :stdin true})

  (fn clojureformat []
    (var filepath (vim.fn.fnameescape (vim.api.nvim_buf_get_name 0)))
    (set filepath (filepath:gsub "%(" "\\("))
    (set filepath (filepath:gsub "%)" "\\)"))
    {:exe "/opt/homebrew/bin/zprint -w"})

  (fn fennelformat []
    (var filepath (vim.fn.fnameescape (vim.api.nvim_buf_get_name 0)))
    (set filepath (filepath:gsub "%(" "\\("))
    (set filepath (filepath:gsub "%)" "\\)"))
    {:exe "fnlfmt --fix"})

  (formatter.setup {:filetype {:arduino [cformat]
                               :c [cformat]
                               :clojure [clojureformat]
                               :css [prettier]
                               :elixir [elixirformat]
                               :fennel [fennelformat]
                               :gleam [gleamformat]
                               :html [prettier]
                               :java [(fn []
                                        {:args [(vim.fn.fnameescape (vim.api.nvim_buf_get_name 0))]
                                         :exe :google-java-format
                                         :stdin true})]
                               :javascript [prettier]
                               :javascriptreact [prettier]
                               :json [prettier]
                               :jsonc [prettier]
                               :less [prettier]
                               :lua [(. (require :formatter.filetypes.lua)
                                        :stylua)]
                               :markdown [prettier]
                               :ocaml [ocamlformat]
                               :python [(fn []
                                          {:exe (.. "cat "
                                                    (vim.fn.fnameescape (vim.api.nvim_buf_get_name 0))
                                                    " | black --quiet -")
                                           :stdin true})]
                               :rust [rustfmt]
                               :scss [prettier]
                               :sh [shfmt]
                               :sql [(fn []
                                       {:exe (.. "cat "
                                                 (vim.fn.fnameescape (vim.api.nvim_buf_get_name 0))
                                                 " | sql-formatter -c "
                                                 (vim.fn.stdpath :config)
                                                 :/sql-formatter.json)
                                        :stdin true})]
                               :typescript [prettier]
                               :typescriptreact [prettier]
                               :vue [prettier]
                               :xml [(fn []
                                       {:args [:--format
                                               (vim.fn.fnameescape (vim.api.nvim_buf_get_name 0))]
                                        :exe :xmllint
                                        :stdin true})]
                               :yaml [prettier]}
                    :log_level vim.log.levels.WARN
                    :logging false}))
