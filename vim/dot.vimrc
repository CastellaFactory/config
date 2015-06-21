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
set ambiwidth=double
set autoindent
set autoread
set backspace=indent,eol,start
set backupdir=~/.vim/backups
if exists('+breakindent')
    set breakindent
endif
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
else
    set clipboard=unnamed
endif
set cmdheight=2
set completeopt=menuone,preview
set directory=~/.vim/backups
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932
set foldenable
set foldmethod=marker
set guioptions+=M    " this flag must be added before 'syntax enable' and 'filetype on'
set history=100
set hlsearch
nohlsearch
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
set termencoding=utf-8
set ttimeoutlen=50
set ttyfast
set undodir=~/.vim/undo
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
    if (system('git rev-parse --is-inside-work-tree') =~# '^\<true')
        lcd `=fnamemodify(system('git rev-parse --show-toplevel'), ':p')`
        pwd
    else
        echohl ErrorMsg | echomsg 'This file is not inside git tree.' | echohl none
    endif
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
function! s:toggle_background_color()  " {{{2
    if &background ==# 'light'
        set background=dark
    else
        set background=light
    endif
endfunction  " 2}}}
function! Preserve(command)  " {{{2
    let l:save_cursor = getpos('.')
    let l:save_win = winsaveview()
    let l:save_search = @/
    try
        execute a:command
    finally
        call setpos('.', l:save_cursor)
        call winrestview(l:save_win)
        let @/ = l:save_search
    endtry
endfunction  " 2}}}
" AllMaps - :map in all modes " {{{2
command! -nargs=* -complete=mapping AllMaps map <args> | map! <args> | lmap <args>
" 2}}}
" DeleteTrailingSpaces  " {{{2
command! -bar -range=% DeleteTrailingSpaces call Preserve('<line1>,<line2>s/\s\+$//ceg')
" 2}}}
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
command! -bar SuspendWithAutomaticCD  call s:cmd_SuspendWithAutomaticCD()
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
" 1}}}

" Mappings  " {{{1
" absolute  " {{{2
" swap colon and semicolon
noremap ;  :
noremap :  ;

" move cursor by display lines
nnoremap j  gj
nnoremap k  gk

" hard to hit <Esc> and <C-[> for me, and to cause InsertLeave.
imap <silent> <C-c>  <Esc>

" for fcitx
if g:is_linux_p && executable('fcitx-remote')
    autocmd MyAutoCmd InsertLeave * call system('fcitx-remote -c')
endif

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
nnoremap <silent> <Space>ob  :<C-u>call <SID>toggle_background_color()<CR>
nnoremap <Space>sp  :<C-u>DeleteTrailingSpaces<CR>
vnoremap <Space>sp  :DeleteTrailingSpaces<CR>
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
" select last changed text (like gv p.146)
nnoremap gc  `[v`]
Objnoremap gc  :<C-u>normal gc<CR>

Objnoremap gv  :<C-u>normal! gv<CR>

Objnoremap ir  i<
Objnoremap ar  a<

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

" NeoBundle  " {{{1
" Basic  " {{{2
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

let g:neobundle#install_process_timeout = 2000

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'
" 2}}}
" Bundles  " {{{2
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-submode'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'mattn/sonictemplate-vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/vimproc.vim', {
            \   'build' : {
            \       'mac' : 'make -f make_mac.mak',
            \       'unix' : 'make -f make_unix.mak'} }
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tpope/vim-fugitive'
NeoBundleLazy 'eagletmt/ghcmod-vim', {
            \   'autoload' : {'filetypes' : ['haskell']} }
NeoBundleLazy 'eagletmt/neco-ghc', {
            \   'autoload' : {'filetypes' : ['haskell']} }
NeoBundleLazy 'eagletmt/unite-haddock', {
            \   'autoload' : {'unite_sources' : 'haddock'} }
NeoBundleLazy 'fatih/vim-go', {
            \   'autoload' : {'filetypes' : ['go']} }
NeoBundleLazy 'junegunn/vim-easy-align', {
            \   'autoload' : {'mappings' : ['<Plug>(EasyAlign)', '<Plug>(LiveEasyAlign)']} }
NeoBundleLazy 'kana/vim-altr', {
            \   'autoload' : {'mappings' : ['<Plug>(altr-forward)', '<Plug>(altr-back)']} }
NeoBundleLazy 'kana/vim-filetype-haskell', {
            \   'autoload' : {'filetypes' : ['haskell']} }
NeoBundleLazy 'kana/vim-operator-replace', {
            \   'autoload' : {'mappings' : ['<Plug>(vim-operator-replace)']} }
NeoBundleLazy 'kana/vim-smartinput', { 'autoload' : {'insert' : 1} }
NeoBundleLazy 'kana/vim-textobj-entire', {
            \   'autoload' : {'mappings' : [ ['xo', 'ae'], ['xo', 'ie'] ]} }
NeoBundleLazy 'kana/vim-textobj-fold', {
            \   'autoload' : {'mappings' : [ ['xo', 'az'], ['xo', 'iz'] ]} }
NeoBundleLazy 'kana/vim-textobj-function', {
            \   'autoload' : {'mappings' : [ ['xo', 'af'], ['xo', 'if'] ]} }
NeoBundleLazy 'kana/vim-textobj-indent', {
            \   'autoload' : {'mappings' : [ ['xo', 'ai'], ['xo', 'ii'], ['xo', 'aI'], ['xo', 'iI'] ]} }
NeoBundleLazy 'kana/vim-textobj-line', {
            \   'autoload' : {'mappings' : [ ['xo', 'al'], ['xo', 'il'] ]} }
NeoBundleLazy 'kana/vim-textobj-syntax', {
            \   'autoload' : {'mappings' : [ ['xo', 'ay'], ['xo', 'iy'] ]} }
NeoBundleLazy 'phildawes/racer', {
            \   'build' : {
            \       'mac' : 'cargo build --release',
            \       'unix' : 'cargo build --release'},
            \   'autoload' : {'filetypes' : ['rust']} }
NeoBundleLazy 'rhysd/vim-clang-format', {
            \   'autoload' : {'mappings' : ['<Plug>(operator-clang-format)']} }
NeoBundleLazy 'rhysd/vim-operator-surround', {
            \   'autoload' : {'mappings' : ['<Plug>(operator-surround-']} }
NeoBundleLazy 'rust-lang/rust.vim', {
            \   'autoload' : {'filetypes' : ['rust']} }
NeoBundleLazy 'scrooloose/syntastic', {
            \   'autoload' : {'commands' : ['SyntasticCheck']} }
NeoBundleLazy 'Shougo/unite.vim', {
            \   'autoload' : {'commands' : [{'name' : 'Unite', 'complete' : 'customlist,unite#complete#source'}]} }
NeoBundleLazy 'SirVer/ultisnips', {
            \   'autoload' : {'functions' : ['UltiSnips#FileTypeChanged']} }
NeoBundleLazy 'tyru/caw.vim', {
            \   'autoload' : {'mappings' : ['<Plug>(caw:']} }
NeoBundleLazy 'ujihisa/unite-haskellimport', {
            \   'autoload' : {'unite_sources' : 'haskellimport'} }
NeoBundleLazy 'Valloric/YouCompleteMe', {
            \   'build' : {
            \       'unix' : 'git submodule update --init --recursive && ./install.sh --clang-completer --system-libclang --gocode-completer',
            \       'mac' : 'git submodule update --init --recursive && ./install.sh --clang-completer --system-libclang --gocode-completer'},
            \   'autoload' : {'insert' : 1, 'commands' : ['YcmCompleter']},
            \   'augroup' : 'youcompletemeStart' }
NeoBundleLazy 'vim-jp/vim-cpp', {
            \   'autoload' : {'filetypes' : ['cpp']} }
NeoBundleLazy 'ocamlmerlin', {
            \   'base' : '~/.opam/system/share/merlin', 'directory' : 'vim',
            \   'type' : 'nosync', 'autoload' : {'filetypes' : ['ocaml']} }
NeoBundleFetch 'powerline/powerline'
" 2}}}
call neobundle#end()
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
" see after/ftplugin
" All filetypes  " {{{2
" for source $MYVIMRC
set formatoptions-=r
set formatoptions-=o
autocmd MyAutoCmd FileType * call s:on_FileType_all()
function! s:on_FileType_all()
    setlocal formatoptions-=r
    setlocal formatoptions-=o
    if empty(&l:omnifunc)
        setlocal omnifunc=syntaxcomplete#Complete
    endif
endfunction

autocmd MyAutoCmd BufReadPost *
            \   if line("'\"") > 1 && line("'\"") <= line("$")
            \ |     execute "normal! g`\""
            \ | endif
" 2}}}
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

nmap <Leader>co  <Plug>(caw:jump:comment-next)
nmap <Leader>cO  <Plug>(caw:jump:comment-prev)
nmap <Leader>cc  <Plug>(caw:i:toggle)
vmap <Leader>cc  <Plug>(caw:i:toggle)
nmap <Leader>ca  <Plug>(caw:a:toggle)
nmap <Leader>cw  <Plug>(caw:wrap:toggle)
" 2}}}
" easy-align  " {{{2
Operatormap <Leader>ea  <Plug>(EasyAlign)
Operatormap <Leader>lea  <Plug>(LiveEasyAlign)
" 2}}}
" fugitive  " {{{2
nnoremap <Leader>gs  :<C-u>Gstatus<CR>
nnoremap <Leader>gc  :<C-u>Gcommit -v<CR>
nnoremap <Leader>ga  :<C-u>Gwrite<CR>
nnoremap <Leader>gd  :<C-u>Gdiff<CR>
nnoremap <Leader>gb  :<C-u>Gblame<CR>
nnoremap <Leader>gp  :<C-u>Git push<CR>
" 2}}}"
"  ghcmod-vim  " {{{2
autocmd MyAutoCmd FileType haskell
            \   nnoremap <buffer> <Leader>t  :<C-u>GhcModType<CR>
            \ | nnoremap <buffer><silent> <Space>/  :<C-u>GhcModTypeClear<CR>:nohlsearch<CR>
" 2}}}
"  operator  " {{{2
" operator-clang-format  " {{{3
autocmd MyAutoCmd FileType c,cpp
            \   execute 'map <buffer> <Leader>x  <Plug>(operator-clang-format)'

let s:bundle = neobundle#get('vim-clang-format')
function! s:bundle.hooks.on_source(bundle)
    " based on Google style. see clang-format-HEAD -dump-config -style='{BasedOnStyle: Google}'
    let g:clang_format#command = executable('clang-format-3.6') ? 'clang-format-3.6' : 'clang-format'
    let g:clang_format#style_options = {
                \   'AccessModifierOffset' : -4,
                \   'AllowShortFunctionsOnASingleLine': 'Inline',
                \   'AllowShortIfStatementsOnASingleLine' : 'false',
                \   'AllowShortLoopsOnASingleLine' : 'false',
                \   'BreakBeforeBraces' : 'Stroustrup',
                \   'ColumnLimit' : 120,
                \   'IndentCaseLabels' : 'false',
                \   'IndentWidth' : 4,
                \   'Standard' : 'Cpp11'
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
" smartinput "{{{2
let s:bundle = neobundle#get('vim-smartinput')
function! s:bundle.hooks.on_post_source(bundle)
    call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')

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
call submode#enter_with('move-to-fold', 'n', '', 'zj', 'zj')
call submode#enter_with('move-to-fold', 'n', '', 'zk', 'zk')
call submode#map('move-to-fold', 'n', '', 'j', 'zj')
call submode#map('move-to-fold', 'n', '', 'k', 'zk')
" 2}}}
" sonictemplate  " {{{2
let g:sonictemplate_vim_template_dir = ['~/.vim/template']
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
    let g:syntastic_c_compiler_options = '-std=c99 -Weverything -Wno-system-headers -Wno-missing-variable-declarations -Wno-missing-prototypes -fno-caret-diagnostics'
    let g:syntastic_c_no_default_include_dirs = 1
    let g:syntastic_c_no_include_search = 1

    let g:syntastic_cpp_checkers = ['gcc', 'cppcheck']
    let g:syntastic_cpp_compiler = 'clang++'
    let g:syntastic_cpp_compiler_options = '-std=c++14 -Weverything -Wno-system-headers -Wno-missing-variable-declarations -Wno-c++98-compat -Wno-missing-prototypes -fno-caret-diagnostics'
    let g:syntastic_cpp_no_default_include_dirs = 1
    let g:syntastic_cpp_no_include_search = 1

    let g:syntastic_haskell_checkers = ['ghc_mod', 'hlint']
    let g:syntastic_python_checkers = ['python', 'flake8']
    let g:syntastic_ruby_checkers = ['mri', 'rubylint', 'rubocop']
    let g:syntastic_go_checkers = ['go', 'golint']
    let g:syntastic_rust_checkers = ['rustc']
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
nnoremap <Space>um  :<C-u>Unite neomru/file<CR>
nnoremap <Space>uf  :<C-u>Unite file<CR>
nnoremap <Space>urm  :<C-u>UniteResume<CR>
nnoremap <Space>unnb  :<C-u>Unite neobundle<CR>
nnoremap <Space>ug   :<C-u>Unite grep:. <CR>
nnoremap ,g  :<C-u>Unite grep:. <CR><C-r><C-w><CR>
nnoremap  <Space>up  :<C-u>Unite buffer file_rec/async:!<CR>

" neomru
let g:neomru#file_mru_limit = 300
let g:neomru#file_mru_ignore_pattern = 'COMMIT_EDITMSG\|\/doc\/.\+\.\(txt\|jax\)$'
let g:neomru#directory_mru_limit = 100

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
" YouCompleteMe  "{{{2
autocmd MyAutoCmd FileType c,cpp
            \   nnoremap <buffer> <Leader>pg  :<C-u>YcmCompleter GoToDefinitionElseDeclaration<CR>

let s:bundle = neobundle#get('YouCompleteMe')
function! s:bundle.hooks.on_source(bundle)
    let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_default/ycm_extra_conf.py'
    let g:ycm_autoclose_preview_window_after_completion = 1
    let g:ycm_show_diagnostics_ui = 0
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_min_num_identifier_candidate_chars = 4
    let g:ycm_seed_identifiers_with_syntax = 1
    let g:ycm_semantic_triggers = {'haskell' : ['.']}
endfunction
unlet s:bundle
" 2}}}
" quickrun  " {{{2
" default setting
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config = {
            \   '_' : {
            \       'outputter' : 'error',
            \       'outputter/error/success' : 'buffer',
            \       'outputter/error/error' : 'quickfix',
            \       'outputter/buffer/split' : ':botright 10sp',
            \       'outputter/buffer/close_on_empty' : 1,
            \       'runner' : 'vimproc',
            \       'runner/vimproc/updatetime' : 60
            \   },
            \   'c' : {
            \       'type' : 'c/clang',
            \       'cmdopt' : '-std=c99 -fno-caret-diagnostics'
            \   },
            \   'cpp' : {
            \       'type' : 'cpp/clang++',
            \       'cmdopt' : '-std=c++14 -fno-caret-diagnostics'
            \   },
            \   'ocaml' : {
            \       'runner' : 'system',
            \       'cmdopt' : '-noprompt',
            \       'exec' : 'TERM="" %c %o < %s'
            \   },
            \   'tex' : {
            \       'command' : 'latexmk',
            \       'cmdopt' : '-pv',
            \       'exec' : '%c %o %s',
            \       'outputter/error/success' : 'null'
            \   },
            \   'markdown' : {
            \       'command' : 'open',
            \       'cmdopt' : '-a',
            \       'args' : 'Marked\ 2',
            \       'exec' : '%c %o %a %s',
            \       'outputter/error/success' : 'null'
            \   }
            \ }

autocmd MyAutoCmd FileType cpp
            \   nnoremap <buffer> <Leader>R  :<C-u>QuickRun cpp_compile<CR>
autocmd MyAutoCmd FileType haskell
            \   nnoremap <buffer> <Leader>R  :<C-u>QuickRun haskell_compile<CR>
" 2}}}
" 1}}}

if filereadable(expand('~/.vim/local.vimrc'))
    source ~/.vim/local.vimrc
endif

set secure

" vim: ft=vim fdm=marker

