require("user.options")
require("user.keymaps")
require("user.plugins")
require("user.autocommands")
require("user.colorscheme")
require("user.cmp")
require("user.telescope")
require("user.treesitter")
require("user.autopairs")
require("user.comment")
require("user.gitsigns")
require("user.lualine")
require("user.indentline")
require("user.lsp")
require("user.expandregion")
require("user.sneak")
require("user.luasnip")
require("user.formatter")
require("user.oil")
require("user.dadbod")
require("user.lilypond")

vim.cmd([[
try
  set diffopt+=vertical
catch
  set diffopt-=internal
endtry

" dont save { and } jumps to jump history
:nnoremap <silent> } :<C-u>execute 'keepjumps normal!' v:count1 . '}'<CR>
:nnoremap <silent> { :<C-u>execute 'keepjumps normal!' v:count1 . '{'<CR>

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("CtrlSF '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'tags'
        call CmdLine("Tags " . l:pattern)
    elseif a:direction == 'search'
        call CmdLine("CocSearch " . l:pattern)
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

vnoremap <silent> <leader>v :call VisualSelection('search', '')<CR>

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <M-[> <Esc>
  tnoremap <C-v><Esc> <Esc>
endif

nmap \ gcc 

" Set marks for last open filetype
nnoremap <leader>gj 'J
nnoremap <leader>gs 'S
nnoremap <leader>gt 'T
nnoremap <leader>gx 'X
nnoremap <leader>gh 'H
nnoremap <leader>gy 'Y
nnoremap <leader>ge 'E

augroup VIMRC
  autocmd!
  autocmd BufLeave *.json                                   normal! mS
  autocmd BufLeave */src/*.js,*/src/*.ts                    normal! mJ
  autocmd BufLeave *.test.js,*.test.ts,*.test.tsx,*.spec.ts normal! mT             
  autocmd BufLeave */src/*.jsx,*/src/*.tsx                  normal! mX        
  autocmd BufLeave *.html                                   normal! mH
  autocmd BufLeave */src/types/*.ts                         normal! mY
  autocmd BufLeave *.e2e.ts                                 normal! mE
augroup END

imap <silent><script><expr> <C-K> copilot#Accept("\<CR>")
imap <C-L> <Plug>(copilot-next)
imap <C-H> <Plug>(copilot-previous)
let g:copilot_no_tab_map = v:true
]])
