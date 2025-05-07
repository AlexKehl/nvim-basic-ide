;;(local ts-utils (require :nvim-treesitter.ts_utils))
(local opts {:silent true})

;; Remap space as leader key
(vim.keymap.set "" :<Space> :<Nop> opts)
(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")

;; Normal --
;; Better window navigation
(vim.keymap.set :n :<C-h> :<C-w>h opts)
(vim.keymap.set :n :<C-j> :<C-w>j opts)
(vim.keymap.set :n :<C-k> :<C-w>k opts)
(vim.keymap.set :n :<C-l> :<C-w>l opts)

;; QuickFix window
(vim.keymap.set :n "]q" :<cmd>cnext<CR> opts)
(vim.keymap.set :n "[q" :<cmd>cprev<CR> opts)

(vim.keymap.set :n :<leader>1 "<cmd>tabn 1<CR>" opts)
(vim.keymap.set :n :<leader>2 "<cmd>tabn 2<CR>" opts)
(vim.keymap.set :n :<leader>3 "<cmd>tabn 3<CR>" opts)
(vim.keymap.set :n :<leader>4 "<cmd>tabn 4<CR>" opts)
(vim.keymap.set :n :<leader>5 "<cmd>tabn 5<CR>" opts)
(vim.keymap.set :n :<leader>6 "<cmd>tabn 6<CR>" opts)
(vim.keymap.set :n :<leader>7 "<cmd>tabn 7<CR>" opts)
(vim.keymap.set :n :<leader>8 "<cmd>tabn 8<CR>" opts)
(vim.keymap.set :n :<leader>9 "<cmd>tabn 9<CR>" opts)
(vim.keymap.set :n :<leader>t "<cmd>tabnew<CR>" opts)

(fn eval-on-save []
  (if (or (= vim.bo.filetype :clojure) (= vim.bo.filetype :fennel))
      (do
        (vim.cmd :w)
        (vim.cmd :ConjureEvalBuf))
      (vim.cmd :w)))

(vim.keymap.set :n :<leader>eg ":ConjureEval (user/reset)<CR>" opts)
(vim.keymap.set :n :<leader>et :<cmd>ConjureCljRunCurrentTest<CR> opts)
(vim.keymap.set :n :<leader>ea ":ConjureEval (user/run-all-tests)<CR>" opts)
(vim.keymap.set :n :<leader>eu ":ConjureEval (user/unmap-defs)<CR>" opts)
(vim.keymap.set :n :<leader>es
                "<Plug>(sexp_move_to_prev_top_element) fna*<Esc><cmd>ConjureEvalRootForm<CR>x0"
                opts)

(vim.keymap.set :n :<leader>mt (fn [] (vim.cmd "mark T") (print "Mark set")))

(vim.keymap.set :n :<C-y>
                (fn []
                  (let [eval (require :conjure.eval)
                        marked-form eval.marked-form]
                    (vim.schedule (fn [] (marked-form :T)))))
                opts)

;; Quick file operations
(vim.keymap.set :n :<leader>w eval-on-save opts)
(vim.keymap.set :n :<leader>q :<cmd>q<CR> opts)

(vim.keymap.set :n :<C-p> :<cmd>Oil<CR> opts)

;; Clear highlights
(vim.keymap.set :n :<leader><cr> :<cmd>nohlsearch<CR> opts)

;; Press kj fast to leave insert mode
(vim.keymap.set :i :kj :<ESC> opts)

;; Stay in indent mode
(vim.keymap.set :v "<" :<gv opts)
(vim.keymap.set :v ">" :>gv opts)

;; Plugins
(vim.keymap.set :n "\\" "<Plug>(comment_toggle_linewise_current)" opts)
(vim.keymap.set :n :<leader>b "<cmd>Git blame<CR>" opts)
(vim.keymap.set :n :<leader>ll "<cmd>diffget //3<CR>" opts)
(vim.keymap.set :n :<leader>lh "<cmd>diffget //2<CR>" opts)

;; Misc
(vim.keymap.set :n :Y :y$ opts)

;; Telescope
(vim.keymap.set :n :<C-f> ":Telescope find_files<CR>" opts)
(vim.keymap.set :n :<C-e> ":Telescope live_grep<CR>" opts)
(vim.keymap.set :n "§" ":Telescope buffers<CR>" opts)
(vim.keymap.set :n :<C-n> ":Telescope command_history<CR>" opts)
(vim.keymap.set :n :z ":Telescope oldfiles<CR>" opts)
(vim.keymap.set :n :<C-q> ":Telescope diagnostics<CR>" opts)

;; todo
(vim.keymap.set :n :<leader>d "<cmd>:e ~/.todo.txt<CR>" opts)

;; Markdown
(vim.keymap.set :n :<leader>md ":MarkdownPreviewToggle<CR>" opts)

(vim.keymap.set :n :<CR> (fn [] (vim.cmd :FormatWrite)) opts)

;; terminal mode esc
(vim.keymap.set :t :<Esc> "<C-\\><C-n>" opts)

(vim.keymap.set :n :<leader>el :<cmd>EslintFixAll<CR> opts)

(vim.keymap.set :n :<leader>jq "?%<CR>x:norm v%gJ<CR>V:!jq<CR>" opts)

;; Copilot Chat
(vim.keymap.set :n :<leader>cc :<cmd>AvanteAsk<CR> opts)

(vim.keymap.set :n :<leader>ch
                (fn []
                  (vim.cmd :TSC)
                  (vim.cmd :TSCOpen)) opts)

(vim.keymap.set :n :<leader>cl (fn []
                                 (vim.cmd "silent! TSCStop")
                                 (vim.cmd :ccl))
                opts)

(vim.keymap.set :n :m (fn []
                        (let [substitute (require :substitute)]
                          (substitute.operator))) opts)

(vim.keymap.set :n :mm (fn []
                         (let [substitute (require :substitute)]
                           (substitute.line))) opts)

(vim.keymap.set :n :M (fn []
                        (let [substitute (require :substitute)]
                          (substitute.eol))) opts)

(vim.keymap.set :x :m (fn []
                        (let [substitute (require :substitute)]
                          (substitute.visual))) opts)

(vim.keymap.set :n :<leader>bb "vip:!zsh<CR>" opts)
(vim.keymap.set :n :<leader>bj "vip:!zsh | jq<CR>" opts)
(vim.keymap.set :n :<leader>jj "vip:!jq<CR>" opts)

(vim.keymap.set :v :v "<Plug>(expand_region_expand)" {})
(vim.keymap.set :v :<C-v> "<Plug>(expand_region_shrink)" {})

(vim.keymap.set :n "<leader>,"
                "A)<ESC><cmd>silent! ConjureEvalCurrentForm<CR><cmd>silent! normal! x0w<CR>"
                opts)

(fn eval-clojure-tests []
  (when (= vim.bo.filetype :clojure)
    (local file-name (vim.api.nvim_buf_get_name 0))
    (if (string.find file-name :_test)
        (vim.cmd :ConjureCljRunCurrentNsTests)
        (vim.cmd :ConjureCljRunAlternateNsTest))))

(vim.keymap.set :n :<C-t> eval-clojure-tests opts)

(vim.keymap.set :i :<C-o> "()<Esc>i" opts)
(vim.keymap.set :i "<C-]>" "[]<Esc>i" opts)
(vim.keymap.set :i :<C-y> "{}<Esc>i" opts)
(vim.keymap.set :i :<C-u> "\"\"<Esc>i" opts)

;; vim-sexp
(vim.keymap.set :n "<leader>:" "<Plug>(sexp_round_tail_wrap_element)" opts)
(vim.keymap.set :n "<leader>;" "<Plug>(sexp_round_head_wrap_element)" opts)
(vim.keymap.set [:x] :af "<Plug>(sexp_outer_list)" opts)
(vim.keymap.set [:o] :af "<Plug>(sexp_outer_list)" opts)
(vim.keymap.set [:x] :if "<Plug>(sexp_inner_list)" opts)
(vim.keymap.set [:o] :if "<Plug>(sexp_inner_list)" opts)
(vim.keymap.set [:x] :aF "<Plug>(sexp_outer_top_list)" opts)
(vim.keymap.set [:o] :aF "<Plug>(sexp_outer_top_list)" opts)
(vim.keymap.set [:x] :iF "<Plug>(sexp_inner_top_list)" opts)
(vim.keymap.set [:o] :iF "<Plug>(sexp_inner_top_list)" opts)
(vim.keymap.set [:x] :al "<Plug>(sexp_outer_string)" opts)
(vim.keymap.set [:o] :al "<Plug>(sexp_outer_string)" opts)
(vim.keymap.set [:x] :il "<Plug>(sexp_inner_string)" opts)
(vim.keymap.set [:o] :il "<Plug>(sexp_inner_string)" opts)
(vim.keymap.set [:x] :ae "<Plug>(sexp_outer_element)" opts)
(vim.keymap.set [:o] :ae "<Plug>(sexp_outer_element)" opts)
(vim.keymap.set [:x] :ie "<Plug>(sexp_inner_element)" opts)
(vim.keymap.set [:o] :ie "<Plug>(sexp_inner_element)" opts)
(vim.keymap.set [:n :x :o] "(" "<Plug>(sexp_move_to_prev_bracket)" opts)
(vim.keymap.set [:n :x :o] ")" "<Plug>(sexp_move_to_next_bracket)" opts)
(vim.keymap.set [:n :x :o] :B "<Plug>(sexp_move_to_prev_element_head)" opts)
(vim.keymap.set [:n :x :o] :W "<Plug>(sexp_move_to_next_element_head)" opts)
(vim.keymap.set [:n :x :o] :gE "<Plug>(sexp_move_to_prev_element_tail)" opts)
(vim.keymap.set [:n :x :o] :E "<Plug>(sexp_move_to_next_element_tail)" opts)
(vim.keymap.set [:n :x :o] "[[" "<Plug>(sexp_move_to_prev_top_element)" opts)
(vim.keymap.set [:n :x :o] "]]" "<Plug>(sexp_move_to_next_top_element)" opts)
(vim.keymap.set [:n :x] :<leader>i "<Plug>(sexp_round_head_wrap_list)" opts)

(vim.keymap.set [:n :x] :<leader>I "<Plug>(sexp_round_tail_wrap_list)" opts)

(vim.keymap.set [:n :x] "<leader>[" "<Plug>(sexp_square_head_wrap_list)" opts)

(vim.keymap.set [:n :x] "<leader>]" "<Plug>(sexp_square_tail_wrap_list)" opts)

(vim.keymap.set [:n :x] "<leader>{" "<Plug>(sexp_curly_head_wrap_list)" opts)

(vim.keymap.set [:n :x] "<leader>}" "<Plug>(sexp_curly_tail_wrap_list)" opts)

(vim.keymap.set [:n :x] "<leader>e[" "<Plug>(sexp_square_head_wrap_element)"
                opts)

(vim.keymap.set [:n :x] "<leader>e]" "<Plug>(sexp_square_tail_wrap_element)"
                opts)

(vim.keymap.set [:n :x] "<leader>e{" "<Plug>(sexp_curly_head_wrap_element)"
                opts)

(vim.keymap.set [:n :x] "<leader>e}" "<Plug>(sexp_curly_tail_wrap_element)"
                opts)

(vim.keymap.set [:n] :<leader>h "<Plug>(sexp_insert_at_list_head)" opts)
(vim.keymap.set [:n] :<leader>l "<Plug>(sexp_insert_at_list_tail)" opts)
(vim.keymap.set [:n] "<leader>@" "<Plug>(sexp_splice_list)" opts)
(vim.keymap.set [:n :x] :<leader>o "<Plug>(sexp_raise_list)" opts)
(vim.keymap.set [:n :x] :<leader>O "<Plug>(sexp_raise_element)" opts)
(vim.keymap.set [:n :x] "[f" "<Plug>(sexp_swap_list_backward)" opts)
(vim.keymap.set [:n :x] "]f" "<Plug>(sexp_swap_list_forward)" opts)
(vim.keymap.set [:n :x] "[e" "<Plug>(sexp_swap_element_backward)" opts)
(vim.keymap.set [:x :n] "]e" "<Plug>(sexp_swap_element_forward)" opts)
(vim.keymap.set :n :<Left> "<Plug>(sexp_emit_tail_element)" opts)
(vim.keymap.set :n :<Right> "<Plug>(sexp_capture_next_element)" opts)
(vim.keymap.set :n :<S-Right> "<Plug>(sexp_emit_head_element)" opts)
(vim.keymap.set :n :<S-Left> "<Plug>(sexp_capture_prev_element)" opts)

(vim.keymap.set [:n :v] :<leader>yf "<Plug>(sexp_clone_list)" opts)
(vim.keymap.set [:n :v] :<leader>ye "<Plug>(sexp_clone_element_sl)" opts)

(vim.keymap.set :n :<leader>fh
                (fn []
                  (let [ts-utils (require :nvim-treesitter.ts_utils)
                        node (ts-utils.get_node_at_cursor)]
                    (print (node:type)))) opts)
