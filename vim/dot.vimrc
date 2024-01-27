" __      ___
" \ \    / (_)
"  \ \  / / _ _ __ ___  _ __ ___
"   \ \/ / | | '_ ` _ \| '__/ __|
"    \  /  | | | | | | | | | (__
"     \/   |_|_| |_| |_|_|  \___|
"
"

" Basic Settings  " {{{1
" Base  " {{{2
augroup Vimrc
    autocmd!
augroup END

language messages C

let g:is_darwin_p = has('mac') || has('macunix')
let g:is_linux_p = !g:is_darwin_p && has('unix')
let g:is_windows_p = has('win32')

function! s:MyEnv()
    let env = {}
    let dot_vim_dir = g:is_windows_p
                    \ ? fnamemodify(expand('$HOME/vimfiles'), ':p')
                    \ : fnamemodify(expand('$HOME/.vim'), ':p')
    let env = {
                \   'path' : {
                \       'user' : dot_vim_dir,
                \       'dein' : {
                \           'bundle' : dot_vim_dir . 'dein',
                \           'toml' : dot_vim_dir . 'dein.toml'
                \       },
                \       'vimrc' : dot_vim_dir . 'vimrc',
                \       'local_vimrc' : dot_vim_dir . 'local.vimrc',
                \       'backup' : dot_vim_dir . 'backups',
                \       'undo' : dot_vim_dir . 'undo'
                \   }
                \ }
    return env
endfunction
let s:env = has_key(s:, 'env') ? s:env : s:MyEnv()

function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
" 2}}}
" Options " {{{2
if has('vim_starting')
    set encoding=utf-8
endif
set ambiwidth=double
set autoindent
set autoread
set backspace=indent,eol,start
let &backupdir = s:env.path.backup
set breakindent
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
else
    set clipboard=unnamed
endif
set cmdheight=2
set completeopt=menuone,preview
let &directory = &backupdir
set fileencoding=utf-8
set fileencodings=utf-8,cp932
set foldenable
set foldmethod=marker
set guioptions+=M    " this flag must be added before 'syntax enable' and 'filetype on'
set history=100
set hlsearch | nohlsearch
set ignorecase
set incsearch
set laststatus=2
if exists('+macmeta')
    set macmeta
endif
set mouse=a
set noerrorbells
set nrformats-=octal
set number
set pumheight=25
set ruler
set scrolloff=3
set shiftround
set shortmess=aoOIt
set showcmd
set showmatch
set showtabline=2
set sidescroll=1
set sidescrolloff=5
set smartcase
set smarttab
set splitbelow splitright
set statusline=%f\ %y\ %r\ %m%=%{(&fenc!=''?&fenc:&enc).':'.&ff}\|%l:%v\|%p%%
set t_vb=
set tabpagemax=20
set termencoding=utf-8
set termguicolors
set ttimeoutlen=50
set ttyfast
let &undodir = s:env.path.undo
set updatetime=500
set virtualedit=block
set visualbell
set whichwrap=b,s,h,l,[,],<,>,~
set wildchar=<TAB>
set wildmenu
set wildmode=longest:full,full
set wrap
set wrapscan

function! s:my_tabline()
    let s = ''
    for i in range(1, tabpagenr('$'))
        let bufnrs = tabpagebuflist(i)
        let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
        let no = i  " display 0-origin tabpagenr.
        let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
        let title = fnamemodify(bufname(bufnr), ':t')
        let title = '[' . (empty(title) ? 'No Name' : title) . ']'
        let s .= '%'.i.'T'
        let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
        let s .= no . ':' . title
        let s .= mod
        let s .= '%#TabLineFill# '
    endfor
    let s .= '%#TabLineFill#%T%=%#TabLine#'
    return s
endfunction
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
" 2}}}
" 1}}}

" Utils  " {{{1
function! s:cd_to_current_buffer_dir()  " {{{2
    lcd %:p:h
    pwd
endfunction  " 2}}}
function! s:cd_to_git_root_dir()  " {{{2
    let save_dir = fnamemodify(getcwd(), ':p')
    lcd %:p:h
    if (system('git rev-parse --is-inside-work-tree') =~# '^\<true')
        lcd `=fnamemodify(system('git rev-parse --show-toplevel'), ':p')`
        pwd
    else
        echohl ErrorMsg | echomsg 'This file is not inside git tree.' | echohl none
        lcd save_dir
    endif
endfunction  " 2}}}
function! s:toggle_background_color()  " {{{2
    if &background ==# 'light'
        set background=dark
    else
        set background=light
    endif
endfunction  " 2}}}
function! Preserve(command)  " {{{2
    let save_cursor = getpos('.')
    let save_win = winsaveview()
    let save_search = @/
    try
        execute a:command
    finally
        call setpos('.', save_cursor)
        call winrestview(save_win)
        let @/ = save_search
    endtry
endfunction  " 2}}}
" AllMaps  " {{{2
command! -nargs=* -complete=mapping AllMaps map <args> | map! <args> | lmap <args>
" 2}}}
" DeleteTrailingSpaces  " {{{2
command! -bar -range=% DeleteTrailingSpaces call Preserve('<line1>,<line2>s/\s\+$//ceg')
" 2}}}
" Ovmap  " {{{2
command! -nargs=+ Ovmap execute 'omap' <q-args> | execute 'vmap' <q-args>
command! -nargs=+ Ovnoremap execute 'onoremap' <q-args> | execute 'vnoremap' <q-args>
command! -nargs=+ Ovunmap execute 'ounmap' <q-args> | execute 'vunmap' <q-args>
" 2}}}
" Nvmap  " {{{2
command! -nargs=+ Nvmap  execute 'nmap' <q-args> | execute 'vmap' <q-args>
command! -nargs=+ Nvnoremap  execute 'nnoremap' <q-args> | execute 'vnoremap' <q-args>
command! -nargs=+ Nvunmap execute 'nunmap' <q-args> | execute 'vunmap' <q-args>
" 2}}}
" 1}}}

" Mappings  " {{{1
" absolute  " {{{2
" swap colon and semicolon
noremap ;  :
noremap :  ;

" move cursor by display lines
noremap j  gj
noremap k  gk

" visual shifting
vnoremap <  <gv
vnoremap >  >gv

" hard to hit <Esc> and <C-[> for me, and to cause InsertLeave.
imap <silent> <C-c>  <Esc>

" for fcitx
if g:is_linux_p && executable('fcitx5-remote')
    autocmd Vimrc InsertLeave * call system('fcitx5-remote -c')
endif

" $MYVIMRC is not set, since vim launched with -u option
execute 'nnoremap <Space>. :<C-u>edit' resolve(s:env.path.vimrc) . '<CR>'
execute 'nnoremap <Space>t. :<C-u>tabnew' resolve(s:env.path.vimrc) . '<CR>'
execute 'nnoremap <Space>s. :<C-u>source' resolve(s:env.path.vimrc) . '<CR>'
" 2}}}
" help  " {{{2
nnoremap <C-h>  :<C-u>help<Space>
nnoremap ,h  :<C-u>help<Space><C-r><C-w><CR>
nnoremap <Space>q  :<C-u>help quickref<CR>

" disable F1
noremap <F1>  <Nop>
inoremap <F1>  <Nop>
" 2}}}
" <Space> stuffs  " {{{2
nnoremap <silent> <Space>ow  :<C-u>setlocal wrap! wrap?<CR>
nnoremap <silent> <Space>ob  :<C-u>call <SID>toggle_background_color()<CR>
nnoremap <Space>sp  :<C-u>DeleteTrailingSpaces<CR>
nnoremap <silent> <Space>r  :<C-u>registers<CR>
nnoremap <silent> <Space>/  :<C-u>nohlsearch<CR>
nnoremap <silent> <Space>v  zMzv
" 2}}}
" movement in Insert mode  " {{{2
inoremap <C-a>  <Home>
inoremap <expr> <C-e>  pumvisible() ? "\<C-e>" : "\<End>"
inoremap <C-d>  <Del>
inoremap <expr> <Up>  pumvisible()? "\<C-p>" : "\<Up>"
inoremap <expr> <Down>  pumvisible()? "\<C-n>" : "\<Down>"
" 2}}}
" Command-line mode  " {{{2
cnoremap <C-p>  <Up>
cnoremap <C-n>  <Down>
cnoremap <C-a>  <Home>
cnoremap <C-e>  <End>

cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
" 2}}}
" misc  " {{{2
" select last changed text (like gv)
nnoremap gc  `[v`]
Ovnoremap gc  :<C-u>normal gc<CR>

Ovnoremap gv  :<C-u>normal! gv<CR>

nnoremap <silent> <Space>cd  :<C-u>call <SID>cd_to_current_buffer_dir()<CR>
nnoremap <silent> <Space>cgd  :<C-u>call <SID>cd_to_git_root_dir()<CR>

" prefix-key for tmux
noremap <C-z>  <Nop>

" disable ZQ(same as :q!)
nnoremap ZQ  <Nop>

" EX-mode, macro
nnoremap Q  q
nnoremap q  <Nop>
" 2}}}
" 1}}}

" Abbreviations  " {{{1
function! s:command_abbrev(lhs, rhs)  " {{{2
    execute 'cnoreabbrev <expr>' a:lhs
                \   '(getcmdtype() == ":" && getcmdline() ==#' '"' . a:lhs . '") ?'
                \   '"' . a:rhs . '" : ' . '"' . a:lhs . '"'
endfunction  " 2}}}
call s:command_abbrev('w!!', 'w !sudo tee % > /dev/null')
call s:command_abbrev('t', 'tabedit')
" 1}}}

" dein {{{1
execute 'set runtimepath^=' . s:env.path.dein.bundle . '/repos/github.com/Shougo/dein.vim'
let g:dein#install_process_timeout = 2000
if dein#min#load_state(s:env.path.dein.bundle)
    call dein#begin(s:env.path.dein.bundle, [s:env.path.vimrc, s:env.path.dein.toml])
    call dein#load_toml(s:env.path.dein.toml)
    call dein#end()
    call dein#save_state()
endif
filetype plugin indent on
syntax enable
" 1}}}

" Colorscheme, Highlight  " {{{1
if !exists('g:colors_name')
    set background=dark
    colorscheme iceberg
endif
" 1}}}

" FileTypes  "{{{1
" see after/ftplugin
" All filetypes  " {{{2
" for source $MYVIMRC
set formatoptions-=r
set formatoptions-=o
autocmd Vimrc FileType * call s:on_FileType_all()
function! s:on_FileType_all()
    setlocal formatoptions-=r
    setlocal formatoptions-=o
    if empty(&omnifunc)
        setlocal omnifunc=syntaxcomplete#Complete
    endif
endfunction

autocmd Vimrc BufReadPost *
            \   if line("'\"") > 1 && line("'\"") <= line("$")
            \ |     execute "normal! g`\""
            \ | endif
" 2}}}
" 1}}}

" Plugins {{{1
" altr  " {{{2
nmap <F3>  <Plug>(altr-forward)
nmap <F2>  <Plug>(altr-back)
" 2}}}
" caw  " {{{2
let g:caw_no_default_keymappings = 1

nmap <Leader>co  <Plug>(caw:jump:comment-next)
nmap <Leader>cO  <Plug>(caw:jump:comment-prev)
nmap <Leader>ci  <Plug>(caw:hatpos:comment)
nmap <Leader>ca  <Plug>(caw:dollarpos:comment)
Nvmap <Leader>cc  <Plug>(caw:hatpos:toggle)
" 2}}}
" devdocs  " {{{2
autocmd Vimrc FileType c,cpp,go,rust,python
            \   nmap <buffer> K <Plug>(devdocs-under-cursor)
" 2}}}
" easy-align  " {{{2
Nvmap <Leader>ea  <Plug>(EasyAlign)
Nvmap <Leader>lea  <Plug>(LiveEasyAlign)
" 2}}}
" operator  " {{{2
" operator-clang-format  " {{{3
autocmd Vimrc FileType c,cpp map <buffer> <Leader>x  <Plug>(operator-clang-format)

" clang-format -style=google -dump-config
let g:clang_format#style_options = {
            \   'AccessModifierOffset' : -4,
            \   'AllowShortIfStatementsOnASingleLine' : 'false',
            \   'AllowShortLoopsOnASingleLine' : 'false',
            \   'BreakBeforeBraces' : 'Stroustrup',
            \   'BreakBeforeBinaryOperators' : 'NonAssignment',
            \   'IndentCaseLabels' : 'false',
            \   'IndentWidth' : 4,
            \   'PointerAlignment' : 'Left'
            \ }
" 3}}}
" operator-surround  {{{3
map <silent>sa  <Plug>(operator-surround-append)
map <silent>sd  <Plug>(operator-surround-delete)
map <silent>sr  <Plug>(operator-surround-replace)
" 3}}}
" operator-replace  {{{3
map <silent>_  <Plug>(operator-replace)
vmap <silent>p <Plug>(operator-replace)
" 3}}}
" operator-flashy  {{{3
map <silent>y  <Plug>(operator-flashy)
nmap <silent>Y <Plug>(operator-flashy)$
" 3}}}
" 2}}}
" submode  "{{{2
call submode#enter_with('changetab', 'n', '', 'gt', 'gt')
call submode#enter_with('changetab', 'n', '', 'gT', 'gT')
call submode#map('changetab', 'n', '', 't', 'gt')
call submode#map('changetab', 'n', '', 'T', 'gT')
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>-')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>+')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>-')
call submode#map('winsize', 'n', '', '-', '<C-w>+')
call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
call submode#map('undo/redo', 'n', '', '-', 'g-')
call submode#map('undo/redo', 'n', '', '+', 'g+')
call submode#enter_with('change-list', 'n', '', 'g;', 'g;')
call submode#enter_with('change-list', 'n', '', 'g,', 'g,')
call submode#map('change-list', 'n', '', ';', 'g;')
call submode#map('change-list', 'n', '', ',', 'g,')
" 2}}}
" UltiSnips  "{{{2
let g:UltiSnipsExpandTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<C-k>'
let g:UltiSnipsJumpBackwardTrigger = '<C-j>'
" 2}}}
" FZF  " {{{2
nnoremap <Space>ub  :<C-u>Buffers<CR>
nnoremap <Space>um  :<C-u>History<CR>
nnoremap <Space>uf  :<C-u>GFiles<CR>
nnoremap <Space>uh  :<C-u>Helptags<CR>
nnoremap <Space>ul  :<C-u>BLines<CR>
nnoremap ,g  :<C-u>Rg <C-r><C-w><CR>
" 2}}}
" quickrun  " {{{2
" default setting
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config = {
            \   '_' : {
            \       'outputter' : 'buffer',
            \       'outputter/buffer/split' : ':botright 10sp',
            \       'outputter/buffer/close_on_empty' : 1,
            \       'runner' : 'job'
            \   },
            \   'cpp' : {
            \       'cmdopt' : '-std=c++17'
            \   }
            \ }
" 2}}}
" 1}}}

if filereadable(s:env.path.local_vimrc)
    source `=s:env.path.local_vimrc`
endif

set secure

" vim: ft=vim fdm=marker

