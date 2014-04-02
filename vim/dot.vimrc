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
augroup MyAutoCmd
    autocmd!
augroup END

language messages C

let g:is_darwin_p = has('mac') || has('macunix')
let g:is_linux_p = !g:is_darwin_p && has('unix')

function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
" 2}}}
" Options " {{{2
if has('+guioptions')
    set guioptions+=M    " this flag must be added before 'syntax enable' and 'filetype on'
endif

set ambiwidth=double
set autoindent
set autoread
set backspace=indent,eol,start
set backupdir=~/.vim/backups
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
else
    set clipboard=unnamed
endif
set cmdheight=2
set completeopt=menuone
set directory=~/.vim/backups
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932
set foldenable
set foldmethod=marker
set history=100
set hlsearch
nohlsearch
set ignorecase
set incsearch
set laststatus=2
if has('+macmeta')
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
set t_vb=
set termencoding=utf-8
set ttimeoutlen=50
set ttyfast
set undodir=~/.vim/undo
set undofile
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
        if title == ''
            let title = 'No Name'
        endif
        let title = '[' . title . ']'
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
" AllMaps - :map in all modes " {{{2
command! -nargs=* -complete=mapping AllMaps
            \   map <args> | map! <args> | lmap <args>
" 2}}}
" CloseTemporaryWindows  " {{{2
command! -bar -nargs=0 CloseTemporaryWindows  call s:cmd_CloseTemporaryWindows()
function! s:cmd_CloseTemporaryWindows()
    let win = range(1, winnr('$'))
    let buftype_pattern = 'nofile\|quickfix\|help'
    call filter(win, '!buflisted(winbufnr(v:val)) && getbufvar(winbufnr(v:val), "&buftype") =~# buftype_pattern')

    let current_winnr = winnr()
    if len(win) == winnr('$')
        call filter(win, 'current_winnr != v:val')
    endif

    for winnr in win
        execute winnr 'wincmd w'
        wincmd c
    endfor
    execute (current_winnr - len(filter(win, 'v:val < current_winnr')))
                \   'wincmd w'
endfunction
" 2}}}
" DeleteTrailingSpaces  " {{{2
command! -bar -nargs=0 -range=% DeleteTrailingSpaces
            \   let s:save_cursor = getpos('.')
            \ | <line1>,<line2>call s:cmd_DeleteTrailingSpaces()
            \ | call setpos('.', s:save_cursor) | unlet s:save_cursor

function! s:cmd_DeleteTrailingSpaces() range
    execute a:firstline . ',' . a:lastline . 's/\s\+$//ceg'
endfunction  " 2}}}
" Objmap - wrapper for textobj mapping  " {{{2
command! -nargs=+ Objmap execute 'omap' <q-args> | execute 'vmap' <q-args>
command! -nargs=+ Objnoremap execute 'onoremap' <q-args> | execute 'vnoremap' <q-args>
command! -nargs=+ Objunmap execute 'ounmap' <q-args> | execute 'vunmap' <q-args>
" 2}}}
" Operatormap - wrapper for operator mapping  " {{{2
command! -nargs=+ Operatormap  execute 'nmap' <q-args> | execute 'vmap' <q-args>
command! -nargs=+ Operatornoremap  execute 'nnoremap' <q-args> | execute 'vnoremap' <q-args>
command! -nargs=+ Operatorunmap execute 'nunmap' <q-args> | execute 'vunmap' <q-args>
" 2}}}
" SuspendWithAutomaticCD  " {{{2
command! -bar -nargs=0 SuspendWithAutomaticCD  call s:cmd_SuspendWithAutomaticCD()
function! s:cmd_SuspendWithAutomaticCD()
    if has('gui_running') && g:is_darwin_p
        call system('open -a iTerm ' . shellescape(getcwd()))
    elseif has('gui_running') && g:is_linux_p
        call system('urxvt -cd ' . shellescape(getcwd()) . ' &')
    elseif exists('$TMUX')    " this vim is running in tmux
        let l:shell_name = split(&shell, '/')[-1]    " zsh, bash, etc...
        let l:windows = split(system('tmux list-windows'), '\n')
        call map(windows, 'split(v:val, "^\\d\\+\\zs:\\s")')
        call filter(windows, 'matchstr(v:val[1], "\\w\\+") ==# shell_name')    " looking for shell_name runnnig windows
        let l:select_command = empty(windows) ? 'new-window' : 'select-window -t ' . windows[0][0]
        " to avoid adding cd to cmdline history, add 'setopt hist_ignore_space' to zshrc and
        " add spaces before 'cd'
        call system('tmux ' . select_command . '&&' . 'tmux send-keys C-u \ cd\ ' . shellescape(getcwd()) . ' C-m C-l')
        redraw!
    else
        suspend
    endif
endfunction  " 2}}}
function! s:cd_to_current_buffer_dir()  " {{{2
    lcd %:p:h
    pwd
endfunction  " 2}}}
function! s:cd_to_git_root_dir()  " {{{2
    if (system('git rev-parse --is-inside-work-tree') =~# '\<true')
        lcd `=fnamemodify(system('git rev-parse --show-toplevel'), ':p')`
        pwd
    else
        echohl ErrorMsg | echomsg 'This file is not inside git tree.' | echohl none
    endif
endfunction  " 2}}}
function! s:keys_to_complete()  " {{{2
    if &l:filetype ==# 'vim'
        return "\<C-x>\<C-v>"      " vim command completion
    elseif &l:omnifunc != ''
        return "\<C-x>\<C-o>"
    else
        return "\<C-n>"
    endif
endfunction  " 2}}}
function! s:set_indent(expandtab_or_noexpandtab)  " {{{2
    if a:expandtab_or_noexpandtab ==# 'expandtab'
        setlocal expandtab
        setlocal tabstop< shiftwidth=4 softtabstop=4
    else
        setlocal noexpandtab
        setlocal tabstop=4 shiftwidth=4 softtabstop<
    endif
endfunction  " 2}}}
function! s:set_short_indent()  " {{{2
    setlocal expandtab
    setlocal tabstop< shiftwidth=2 softtabstop=2
endfunction  " 2}}}
function! s:toggle_fullscreen()  " {{{2
    if g:is_darwin_p
        if has('gui_running')
            setlocal fullscreen!
        else
            if executable('cliclick')
                call system('cliclick kd:cmd kp:return ku:cmd')
            else
                echohl ErrorMsg | echomsg 'cliclick is not installed.' | echohl none
            endif
        endif
    elseif g:is_linux_p
        if executable('xdotool')
            " use super+ctrl+l instead of super+f. (see xmonad.hs)
            call system('xdotool key super+ctrl+l')
        else
            echohl ErrorMsg | echomsg 'xdotool is not installed.' | echohl none
        endif
    endif
endfunction  " 2}}}
" 1}}}

" Mappings  " {{{1
" absolute  " {{{2
" swap colon and semicolon
noremap ;  :
noremap :  ;

" follow symbolic link (don't use $MYVIMRC)
nnoremap <Space>.  :<C-u>edit `=resolve(fnamemodify("~/.vim/vimrc", ':p'))`<CR>
nnoremap <Space>t.  :<C-u>tabnew `=resolve(fnamemodify("~/.vim/vimrc", ':p'))`<CR>
nnoremap <Space>s.  :<C-u>source `=resolve(fnamemodify("~/.vim/vimrc", ':p'))`<CR>
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
nnoremap <silent> <Space>of  :<C-u>call <SID>toggle_fullscreen()<CR>
nnoremap <Space>sp  :DeleteTrailingSpaces<CR>
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
cnoremap <M-b>  <S-Left>
cnoremap <M-f>  <S-Right>

cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
" 2}}}
" misc  " {{{2
" select last changed text (like gv p.146)
nnoremap gc  `[v`]
Objnoremap gc  :<C-u>normal gc<CR>

onoremap gv  :<C-u>normal! gv<CR>

nnoremap <silent> <Space>cd  :<C-u>call <SID>cd_to_current_buffer_dir()<CR>
nnoremap <silent> <Space>cgd  :<C-u>call <SID>cd_to_git_root_dir()<CR>

nnoremap ZZ  :<C-u>SuspendWithAutomaticCD<CR>

" prefix-key for tmux
noremap <C-z>  <Nop>

" disable ZQ(same as :q!)
nnoremap ZQ  <Nop>

" EX-mode, macro
nnoremap Q  q
nnoremap q  <Nop>

inoremap <expr> <C-x><C-x>  <SID>keys_to_complete()

cnoremap w!! w !sudo tee % > /dev/null
" 2}}}
" 1}}}

" NeoBundle  " {{{1
" Basic  " {{{2
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

let g:neobundle#install_process_timeout = 2000

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'
" 2}}}
" Bundles  " {{{2
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-submode'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/vimproc.vim', {
            \   'build' : {
            \       'mac' : 'make -f make_mac.mak',
            \       'unix' : 'make -f make_unix.mak'} }
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-repeat'
NeoBundleLazy 'eagletmt/ghcmod-vim', {
            \   'autoload' : {'filetypes' : ['haskell']} }
NeoBundleLazy 'eagletmt/neco-ghc', {
            \   'autoload' : {'filetypes' : ['haskell']} }
NeoBundleLazy 'eagletmt/unite-haddock', {
            \   'autoload' : {'unite_sources' : 'haddock'} }
NeoBundleLazy 'junegunn/vim-easy-align', {
            \   'autoload' : {'mappings' : ['<Plug>(EasyAlign)']} }
NeoBundleLazy 'kana/vim-altr', {
            \   'autoload' : {'mappings' : ['<Plug>(altr-forward', '<Plug>(altr-back)']} }
NeoBundleLazy 'kana/vim-fakeclip', { 'autoload' : {'terminal' : 1} }
NeoBundleLazy 'kana/vim-filetype-haskell', {
            \   'autoload' : {'filetypes' : ['haskell']} }
NeoBundleLazy 'kana/vim-operator-replace', {
            \   'autoload' : {'mappings' : ['<Plug>(vim-operator-replace)']} }
NeoBundleLazy 'kana/vim-smartinput', { 'autoload' : {'insert' : 1} }
NeoBundleLazy 'kana/vim-textobj-entire', {
            \   'autoload' : {'mappings' : [ ['xo', 'ae'], ['xo', 'ie'] ]} }
NeoBundleLazy 'kana/vim-textobj-function', {
            \   'autoload' : {'mappings' : [ ['xo', 'af'], ['xo', 'if'] ]} }
NeoBundleLazy 'kana/vim-textobj-indent', {
            \   'autoload' : {'mappings' : [ ['xo', 'ai'], ['xo', 'ii'], ['xo', 'aI'], ['xo', 'iI'] ]} }
NeoBundleLazy 'kana/vim-textobj-lastpat', {
            \   'autoload' : {'mappings' : [ ['xo', 'a/'], ['xo', 'i/'], ['xo', 'a?'], ['xo', 'i?'] ]} }
NeoBundleLazy 'kana/vim-textobj-line', {
            \   'autoload' : {'mappings' : [ ['xo', 'al'], ['xo', 'il'] ]} }
NeoBundleLazy 'kana/vim-textobj-syntax', {
            \   'autoload' : {'mappings' : [ ['xo', 'ay'], ['xo', 'iy'] ]} }
NeoBundleLazy 'rhysd/vim-clang-format', {
            \   'autoload' : {'mappings' : ['<Plug>(operator-clang-format)']} }
NeoBundleLazy 'rhysd/vim-operator-surround', {
            \   'autoload' : {'mappings' : ['<Plug>(operator-surround-']} }
NeoBundleLazy 'scrooloose/syntastic', {
            \   'autoload' : {'commands' : ['SyntasticCheck']} }
NeoBundleLazy 'Shougo/unite.vim', {
            \   'autoload' : {'commands' : [{'name' : 'Unite', 'complete' : 'customlist,unite#complete_source'}]}}
NeoBundleLazy 'Shougo/unite-outline', {
            \   'autoload' : {'unite_sources' : 'outline'} }
NeoBundleLazy 'Shougo/vimfiler.vim', {
            \   'autoload' : {'commands' : ['VimFiler', 'VimFilerCurrentDir', 'VimFilerBufferDir',
            \                               'VimFilerSplit', 'VimFilerExplorer', 'VimFilerDouble']}, 'explorer' : 1 }
NeoBundleLazy 'SirVer/ultisnips', {
            \   'autoload' : {'functions' : ['UltiSnips#FileTypeChanged']} }
NeoBundleLazy 'tyru/caw.vim', {
            \   'autoload' : {'mappings' : ['<Plug>(caw:']} }
NeoBundleLazy 'Valloric/YouCompleteMe', {
            \   'build' : {
            \       'unix' : 'git submodule update --init --recursive && ./install.sh --clang-completer --system-libclang',
            \       'mac' : 'git submodule update --init --recursive && ./install.sh --clang-completer'},
            \   'autoload' : {'insert' : 1, 'commands' : ['YcmCompleter']},
            \   'augroup' : 'youcompletemeStart' }
NeoBundleLazy 'vim-jp/cpp-vim', {
            \   'autoload' : {'filetypes' : ['cpp']} }
NeoBundleFetch 'Lokaltog/powerline'
" 2}}}
filetype plugin indent on
NeoBundleCheck
" 1}}}

" Colorscheme, Highlight  " {{{1
syntax enable
if !exists('g:colors_name')
    let g:mycolor_termtrans = 1
    colorscheme mycolor
    set background=dark
endif
" 1}}}

" FileTypes  "{{{1
" All filetypes  " {{{2
set formatoptions-=r       " for reloading $MYVIMRC
set formatoptions-=o
autocmd MyAutoCmd FileType * call s:on_FileType_all()
function! s:on_FileType_all()
    setlocal formatoptions-=r
    setlocal formatoptions-=o
    if &l:omnifunc == ''
        setlocal omnifunc=syntaxcomplete#Complete
    endif
endfunction

autocmd MyAutoCmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
" 2}}}
" c  " {{{2
autocmd MyAutoCmd FileType c call s:set_indent('expandtab')
" 2}}}
" cpp  " {{{2
autocmd MyAutoCmd FileType cpp call s:on_FileType_cpp()
function! s:on_FileType_cpp()
    call s:set_indent('expandtab')
    setlocal matchpairs+=<:>
    " add cpp header files dir to path
endfunction
" 2}}}
" haskell  " {{{2
autocmd MyAutoCmd FileType haskell call s:on_FileType_haskell()
function! s:on_FileType_haskell()
    call s:set_indent('expandtab')
    setlocal omnifunc=necoghc#omnifunc
endfunction
" 2}}}
" makefile  " {{{2
autocmd MyAutoCmd FileType make call s:set_indent('noexpandtab')
" 2}}}
" python  " {{{2
autocmd MyAutoCmd FileType python call s:set_indent('expandtab')
" 2}}}
" ruby  " {{{2
autocmd MyAutoCmd FileType ruby call s:set_short_indent()
" 2}}}
" scheme  " {{{2
autocmd MyAutoCmd FileType scheme call s:on_FileType_scheme()
function! s:on_FileType_scheme()
    call s:set_short_indent()
    setlocal lisp
    let b:is_gauche = 1
endfunction
" 2}}}
" vim  " {{{2
autocmd MyAutoCmd FileType vim call s:set_indent('expandtab')
" 2}}}
" zsh,sh  " {{{2
autocmd MyAutoCmd FileType zsh,sh call s:set_indent('expandtab')
" 2}}}"
" 1}}}

" Plugins {{{1
" altr  " {{{2
nmap <F3>  <Plug>(altr-forward)
nmap <F2>  <Plug>(altr-back)

let s:bundle = neobundle#get('vim-altr')
function! s:bundle.hooks.on_post_source(bundle)
    call altr#define('vimrc', 'gvimrc')
endfunction
unlet s:bundle
" 2}}}
" caw  " {{{2
let g:caw_no_default_keymappings = 1
let g:caw_i_sp_blank = ' '

nmap cci  <Plug>(caw:i:comment)
nmap cca  <Plug>(caw:a:comment)
nmap cco  <Plug>(caw:jump:comment-next)
nmap ccO  <Plug>(caw:jump:comment-prev)
nmap <Leader>cc  <Plug>(caw:i:toggle)
vmap <Leader>cc  <Plug>(caw:i:toggle)
nmap <Leader>ca  <Plug>(caw:a:toggle)
nmap <Leader>cw  <Plug>(caw:wrap:toggle)
" 2}}}
" easy-align  " {{{2
map <Leader>a  <Plug>(EasyAlign)
" 2}}}
" fugitive  " {{{2
nnoremap <Leader>gs  :<C-u>Gstatus<CR>
nnoremap <Leader>gc  :<C-u>Gcommit -v<CR>
nnoremap <Leader>gC  :<C-u>Gcommit<CR>
nnoremap <Leader>ga  :<C-u>Gwrite<CR>
nnoremap <Leader>gd  :<C-u>Gdiff<CR>
nnoremap <Leader>gb  :<C-u>Gblame<CR>
nnoremap <Leader>gp  :<C-u>Git push<CR>
nnoremap <Leader>gP  :<C-u>Git pull<CR>
" 2}}}"
"  ghcmod-vim  " {{{2
autocmd MyAutoCmd FileType haskell nnoremap <buffer> <Leader>t  :<C-u>GhcModType<CR>
autocmd MyAutoCmd FileType haskell nnoremap <buffer><silent> <C-n>  :<C-u>GhcModTypeClear<CR>:nohlsearch<CR>
" 2}}}
" lightline  " {{{2
let g:lightline = {
            \   'colorscheme' : 'wombat',
            \   'active' : {'left' : [['mode', 'paste'], ['fugitive', 'readonly', 'filename', 'modified']]},
            \   'component_function' : {'fugitive' : 'MyFugitive'},
            \   'enable' : {'statusline' : 1, 'tabline' : 0}
            \ }

function! MyFugitive()
    try
        if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
            return fugitive#head()
        endif
    catch
    endtry
    return ''
endfunction
" 2}}}
"  operator  " {{{2
" operator-clang-format  " {{{3
autocmd MyAutoCmd FileType cpp map <buffer> <Leader>x  <Plug>(operator-clang-format)

let s:bundle = neobundle#get('vim-clang-format')
function! s:bundle.hooks.on_source(bundle)
    " Mac: homebrew
    " Linux: build from sources and make symbolic link
    " based on Google style. see clang-format-HEAD -dump-config -style='{BasedOnStyle: Google}'
    let g:clang_format#command = 'clang-format-HEAD'
    let g:clang_format#style_options = {
                \   'AccessModifierOffset' : -4,
                \   'AllowShortIfStatementsOnASingleLine' : 'false',
                \   'AllowShortLoopsOnASingleLine' : 'false',
                \   'BreakBeforeBraces' : 'Stroustrup',
                \   'IndentWidth' : 4,
                \   'Standard' : 'Cpp11',
                \   'TabWidth' : 4
                \ }
endfunction
unlet s:bundle
" 3}}}
" operator-replace  " {{{3
map _  <Plug>(operator_replace)
" 3}}}"
" operator-surround  {{{3
map <silent>sa  <Plug>(operator-surround-append)
map <silent>sd  <Plug>(operator-surround-delete)
map <silent>sr  <Plug>(operator-surround-replace)
" 3}}}
" 2}}}
"  submode  "{{{2
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
" 2}}}
" smartinput "{{{2
let s:bundle = neobundle#get('vim-smartinput')
function! s:bundle.hooks.on_post_source(bundle)
    call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
    call smartinput#map_to_trigger('i', '<BS>', '<BS>', '<BS>')
    call smartinput#map_to_trigger('i', '<CR>', '<CR>', '<CR>')

    call smartinput#define_rule({ 'at' : '\s\+\%#', 'char' : '<CR>', 'input' : "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', '')) <Bar> echo 'delete trailing spaces'<CR><CR>" })
    call smartinput#define_rule({ 'at' : '(\%#)', 'char' : '<Space>', 'input' : '<Space><Space><Left>' })
    call smartinput#define_rule({ 'at' : '{\%#}', 'char' : '<Space>', 'input' : '<Space><Space><Left>' })
    call smartinput#define_rule({ 'at' : '\[\%#\]', 'char' : '<Space>', 'input' : '<Space><Space><Left>' })
    call smartinput#define_rule({ 'at' : '( \%# )', 'char' : '<BS>', 'input' : '<Del><BS>' })
    call smartinput#define_rule({ 'at' : '{ \%# }', 'char' : '<BS>', 'input' : '<Del><BS>' })
    call smartinput#define_rule({ 'at' : '\[ \%# \]', 'char' : '<BS>', 'input' : '<Del><BS>' })
endfunction
unlet s:bundle
" 2}}}
" Syntastic  " {{{2
let s:bundle = neobundle#get('syntastic')
function! s:bundle.hooks.on_source(bundle)
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_enable_highlighting = 0
    let g:syntastic_cppcheck_config_file = '~/.vim/syntastic_config/cppcheck'
    let g:syntastic_mode_map = {'mode': 'passive'}

    let g:syntastic_c_checkers = ['gcc', 'cppcheck']
    let g:syntastic_c_compier = 'clang'
    let g:syntastic_c_compiler_options = '-std=c11 -Weverything -Wno-system-headers -Wno-missing-variable-declarations -Wno-missing-prototypes -fno-caret-diagnostics'
    let g:syntastic_c_no_default_include_dirs = 1
    let g:syntastic_c_no_include_search = 1

    let g:syntastic_cpp_checkers = ['gcc', 'cppcheck']
    let g:syntastic_cpp_compiler = 'clang++'
    let g:syntastic_cpp_compiler_options = '-std=c++11 -Weverything -Wno-system-headers -Wno-missing-variable-declarations -Wno-c++98-compat -Wno-missing-prototypes -fno-caret-diagnostics'
    let g:syntastic_cpp_no_default_include_dirs = 1
    let g:syntastic_cpp_no_include_search = 1

    let g:syntastic_haskell_checkers = ['ghc_mod', 'hlint']
    let g:syntastic_python_checkers = ['python', 'flake8']
    let g:syntastic_ruby_checkers = ['mri', 'rubylint', 'rubocop']
endfunction
unlet s:bundle
" 2}}}
" UltiSnips  "{{{2
let s:bundle = neobundle#get('ultisnips')
function! s:bundle.hooks.on_source(bundle)
    let g:UltiSnipsSnippetDirectories = ['ultisnips-snippets']
    let g:UltiSnipsExpandTrigger = '<C-k>'
    let g:UltiSnipsJumpForwardTrigger = '<C-k>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-j>'
    let g:snips_author = 'Castella'
endfunction
unlet s:bundle
" 2}}}
" unite  " {{{2
nnoremap <Space>ub  :<C-u>Unite buffer<CR>
nnoremap <Space>ut  :<C-u>Unite tab<CR>
nnoremap <Space>ufr  :<C-u>Unite file_mru<CR>
nnoremap <Space>udr  :<C-u>Unite directory_mru<CR>
nnoremap <Space>urm  :<C-u>UniteResume<CR>
nnoremap <Space>uff  :<C-u>Unite file<CR>
nnoremap <Space>uol  :<C-u>Unite outline<CR>
nnoremap <Space>unnb  :<C-u>Unite neobundle<CR>
nnoremap <Space>ug   :<C-u>Unite grep:. <CR>
nnoremap ,g  :<C-u>Unite grep:. <CR><C-r><C-w><CR>
nnoremap  <Space>up  :<C-u>Unite buffer file_rec/async:!<CR>

let s:bundle = neobundle#get('unite.vim')
function! s:bundle.hooks.on_source(bundle)
    let g:unite_enable_start_insert = 1
    let g:unite_force_overwrite_statusline = 0

    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nocolor --nogroup'
    let g:unite_source_grep_recursive_opt = ''

    autocmd MyAutoCmd FileType unite imap <buffer> <C-g>  <Plug>(unite_exit)
                \ | nmap <buffer> <C-g>  <Plug>(unite_exit)
endfunction
unlet s:bundle
" 2}}}
" vimfiler  " {{{2
nnoremap <Space>fc  :<C-u>VimFilerCurrentDir<CR>
nnoremap <Space>fb  :<C-u>VimFilerBufferDir<CR>
let g:loaded_netrwPlugin = 1

let s:bundle = neobundle#get('vimfiler.vim')
function! s:bundle.hooks.on_source(bundle)
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_safe_mode_by_default = 0
    let g:vimfiler_force_overwrite_statusline = 0
endfunction
unlet s:bundle
" 2}}}
" YouCompleteMe  "{{{2
autocmd MyAutoCmd FileType c,cpp,python nnoremap <buffer> <Leader>pg  :<C-u>YcmCompleter GoToDefinitionElseDeclaration<CR>
            \ | nnoremap <buffer> <Leader>pd  :<C-u>YcmCompleter GoToDefinition<CR>
            \ | nnoremap <buffer> <Leader>pc  :<C-u>YcmCompleter GoToDeclaration<CR>

let s:bundle = neobundle#get('YouCompleteMe')
function! s:bundle.hooks.on_source(bundle)
    let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_default/ycm_extra_conf.py'
    let g:ycm_show_diagnostics_ui = 0
    let g:ycm_min_num_identifier_candidate_chars = 4
    let g:ycm_seed_identifiers_with_syntax = 1
    let g:ycm_filetype_specific_completion_to_disable = {'vim' : 1}
    let g:ycm_key_list_select_completion = ['<C-n>']
    let g:ycm_key_list_previous_completion = ['<C-p>']
    " add semantic triggers
    let g:ycm_semantic_triggers = {
                \   'haskell' : ['.']
                \ }
endfunction
unlet s:bundle
" 2}}}
" quickrun  " {{{2
" default setting
let g:quickrun_config = {}
let g:quickrun_config._ = {
            \   'outputter' : 'error',
            \   'outputter/error/success' : 'buffer',
            \   'outputter/error/error' : 'quickfix',
            \   'outputter/buffer/split' : ':botright 8sp',
            \   'outputter/buffer/close_on_empty' : 1,
            \   'runner' : 'vimproc',
            \   'runner/vimproc/updatetime' : 60,
            \ }
let g:quickrun_config.c = {
            \   'type' : 'c/clang',
            \   'cmdopt' : '-fno-caret-diagnostics',
            \ }
let g:quickrun_config.cpp = {
            \   'type' : 'cpp/clang++',
            \   'cmdopt' : '-std=c++11 -fno-caret-diagnostics',
            \ }
" for compile
let g:quickrun_config.cpp_compile = {
            \   'command' : 'clang++',
            \   'cmdopt' : '-std=c++11 -Wall -Wextra',
            \   'exec' : '%c %o -o %s:r %s:p',
            \   'outputter' : 'quickfix',
            \ }
let g:quickrun_config.c_compile = {
            \   'command' : 'clang',
            \   'cmdopt' : '-std=c11 -Wall -Wextra',
            \   'exec' : '%c %o -o %s:r %s:p',
            \   'outputter' : 'quickfix',
            \ }
let g:quickrun_config.haskell_compile = {
            \   'command' : 'ghc',
            \   'cmdopt' : '-O --make',
            \   'exec' : '%c %o -o %s:r %s:p',
            \   'outputter' : 'quickfix',
            \ }

autocmd MyAutoCmd FileType c nnoremap <buffer> <Leader>R  :<C-u>QuickRun c_compile<CR>
autocmd MyAutoCmd FileType cpp nnoremap <buffer> <Leader>R  :<C-u>QuickRun cpp_compile<CR>
autocmd MyAutoCmd FileType haskell nnoremap <buffer> <Leader>R  :<C-u>QuickRun haskell_compile<CR>
" 2}}}
" 1}}}

set secure

" vim: ft=vim fdm=marker

