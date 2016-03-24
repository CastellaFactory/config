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

function! s:MyEnv()
    let env = {}
    let dot_vim_dir = fnamemodify(expand('$HOME/.vim'), ':p')
    let ghq_root = substitute(system('ghq root'), '\n\+$', '', '')
    let env = {
                \   'path' : {
                \       'user' : dot_vim_dir,
                \       'bundle' : dot_vim_dir . 'plugged',
                \       'vimrc' : dot_vim_dir . 'vimrc',
                \       'local_vimrc' : dot_vim_dir . 'local.vimrc',
                \       'backup' : dot_vim_dir . 'backups',
                \       'undo' : dot_vim_dir . 'undo'
                \   },
                \   'language' : {
                \       'c' : {
                \           'compiler' : executable('clang-3.7') ? 'clang-3.7' : 'clang'
                \       },
                \       'cpp' : {
                \           'compiler' : executable('clang++-3.7') ? 'clang++-3.7' : 'clang++',
                \           'formatter' : executable('clang-format-3.7') ? 'clang-format-3.7' : 'clang-format'
                \       },
                \       'rust' : {
                \           'src' : ghq_root . '/github.com/rust-lang/rust/src'
                \       }
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
set ambiwidth=double
set autoindent
set autoread
set backspace=indent,eol,start
let &backupdir = s:env.path.backup
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
let &directory = &backupdir
set encoding=utf-8
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
set ttimeoutlen=50
set ttyfast
let &undodir = s:env.path.undo
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
" SuspendWithAutomaticCD  " {{{2
command! -bar SuspendWithAutomaticCD  call s:cmd_SuspendWithAutomaticCD()
function! s:cmd_SuspendWithAutomaticCD()
    if has('gui_running') && g:is_darwin_p
        call system('open -a iTerm ' . shellescape(getcwd()))
    elseif has('gui_running') && g:is_linux_p
        call system('urxvt -cd ' . shellescape(getcwd()) . ' &')
    elseif exists('$TMUX')
        let shell_name = split(&shell, '/')[-1]
        let windows = split(system('tmux list-windows'), '\n')
        call map(windows, 'split(v:val, "^\\d\\+\\zs:\\s")')
        call filter(windows, 'matchstr(v:val[1], "\\w\\+") ==# shell_name')    " looking for shell_name runnnig windows
        let select_command = empty(windows) ? 'new-window' : 'select-window -t ' . windows[0][0]
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
Ovnoremap gc  :<C-u>normal gc<CR>

Ovnoremap gv  :<C-u>normal! gv<CR>

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

" vim-plug  " {{{1
" Basic  " {{{2
let g:plug_timeout = 120
call plug#begin(s:env.path.bundle)
" 2}}}
" Bundles  " {{{2
Plug 'kana/vim-operator-user'
Plug 'kana/vim-submode'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'NLKNguyen/papercolor-theme'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'thinca/vim-quickrun'
Plug 'cohama/lexima.vim', {'on' : []}
Plug 'eagletmt/ghcmod-vim', {'for' : 'haskell'}
Plug 'eagletmt/neco-ghc', {'for' : 'haskell'}
Plug 'fatih/vim-go', {'for' : 'go'}
Plug 'itchyny/vim-haskell-indent', {'for' : 'haskell'}
Plug 'junegunn/vim-easy-align', {'on' : ['<Plug>(EasyAlign)', '<Plug>(LiveEasyAlign)']}
Plug 'kana/vim-altr', {'on' : ['<Plug>(altr-forward)','<Plug>(altr-back)']}
Plug 'leafgarland/typescript-vim', {'for' : 'typescript'}
Plug 'rhysd/devdocs.vim', {'on' : '<Plug>(devdocs-under-cursor)'}
Plug 'rhysd/vim-clang-format', {'on' : '<Plug>(operator-clang-format)'}
Plug 'rhysd/vim-crystal', {'for' : 'crystal'}
Plug 'rhysd/vim-operator-surround', {'on' : ['<Plug>(operator-surround-append)',
            \   '<Plug>(operator-surround-delete)', '<Plug>(operator-surround-replace)']}
Plug 'rust-lang/rust.vim', {'for' : 'rust'}
Plug 'scrooloose/syntastic', {'on' : 'SyntasticCheck'}
Plug 'Shougo/unite.vim', {'on' : 'Unite'}
Plug 'SirVer/ultisnips', {'on' : []}
Plug 'tyru/caw.vim', {'on' : ['<Plug>(caw:tildepos:toggle)', '<Plug>(caw:dollarpos:comment)',
            \   '<Plug>(caw:tildepos:comment)', '<Plug>(caw:jump:comment-prev)',
            \   '<Plug>(caw:jump:comment-next)']}
Plug 'Valloric/YouCompleteMe', {
            \   'do' : 'git submodule update --init --recursive && ./install.py --clang-completer --system-libclang --gocode-completer --racer-completer',
            \   'on' : []}
Plug 'vim-jp/vim-cpp', {'for' : 'cpp'}
Plug '~/.opam/system/share/merlin/vim', {'for' : 'ocaml'}
" 2}}}
" LazyLoading  " {{{2
augroup Load-InsertEnter
    autocmd!
    autocmd InsertEnter * call plug#load('YouCompleteMe', 'lexima.vim')
                \|  autocmd! Load-InsertEnter
augroup END

augroup Load-FileTypeChanged
    autocmd!
    autocmd FileType * call plug#load('ultisnips')
                \|  autocmd! Load-FileTypeChanged
augroup END

autocmd! User YouCompleteMe call youcompleteme#Enable()
autocmd! User lexima.vim call config#lexima_set_rule()
" 2}}}
call plug#end()
" 1}}}

" Colorscheme, Highlight  " {{{1
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
    if empty(&omnifunc)
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
" 2}}}
" caw  " {{{2
let g:caw_no_default_keymappings = 1
let g:caw_tildepos_sp_blank = ' '

nmap <Leader>co  <Plug>(caw:jump:comment-next)
nmap <Leader>cO  <Plug>(caw:jump:comment-prev)
nmap <Leader>ci  <Plug>(caw:tildepos:comment)
nmap <Leader>ca  <Plug>(caw:dollarpos:comment)
Nvmap <Leader>cc  <Plug>(caw:tildepos:toggle)
" 2}}}
" devdocs  " {{{2
autocmd MyAutoCmd FileType c,cpp,rust,haskell nmap <buffer> K <Plug>(devdocs-under-cursor)
" 2}}}
" easy-align  " {{{2
Nvmap <Leader>ea  <Plug>(EasyAlign)
Nvmap <Leader>lea  <Plug>(LiveEasyAlign)
" 2}}}
" ghcmod-vim  " {{{2
autocmd MyAutoCmd FileType haskell
            \   nnoremap <buffer> <Leader>t  :<C-u>GhcModType<CR>
            \ | nnoremap <buffer><silent> <Space>/  :<C-u>GhcModTypeClear<CR>:nohlsearch<CR>
" 2}}}
" neco-ghc  " {{{2
autocmd MyAutoCmd FileType haskell setlocal omnifunc=necoghc#omnifunc
" 2}}} "
"  operator  " {{{2
" operator-clang-format  " {{{3
autocmd MyAutoCmd FileType c,cpp map <buffer> <Leader>x  <Plug>(operator-clang-format)

" clang-format -style=google -dump-config
let g:clang_format#command = s:env.language.cpp.formatter
let g:clang_format#style_options = {
            \   'AccessModifierOffset' : -4,
            \   'AllowShortIfStatementsOnASingleLine' : 'false',
            \   'AllowShortLoopsOnASingleLine' : 'false',
            \   'BreakBeforeBinaryOperators' : 'NonAssignment',
            \   'BreakBeforeBraces' : 'Stroustrup',
            \   'IndentCaseLabels' : 'false',
            \   'IndentWidth' : 4
            \ }
" 3}}}
" operator-surround  {{{3
map <silent>sa  <Plug>(operator-surround-append)
map <silent>sd  <Plug>(operator-surround-delete)
map <silent>sr  <Plug>(operator-surround-replace)
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
" Syntastic  " {{{2
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_enable_highlighting = 0
let g:syntastic_mode_map = {'mode': 'passive'}

let g:syntastic_cpp_checkers = ['gcc', 'cppcheck']
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++14 -Weverything -Wno-system-headers -Wno-c++98-compat'
let g:syntastic_cppcheck_config_file = s:env.path.user . 'syntastic_config/cppcheck'

let g:syntastic_ruby_checkers = ['mri', 'rubylint', 'rubocop']
let g:syntastic_go_checkers = ['go', 'golint']
let g:syntastic_typescript_checkers = ['tsc', 'tslint']
" 2}}}
" UltiSnips  "{{{2
let g:UltiSnipsExpandTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<C-k>'
let g:UltiSnipsJumpBackwardTrigger = '<C-j>'
" 2}}}
" unite  " {{{2
nnoremap <Space>ub  :<C-u>Unite buffer<CR>
nnoremap <Space>um  :<C-u>Unite neomru/file<CR>
nnoremap <Space>uf  :<C-u>Unite file<CR>
nnoremap <Space>urm  :<C-u>UniteResume<CR>
nnoremap <Space>ug   :<C-u>Unite grep:. <CR>
nnoremap ,g  :<C-u>Unite grep:. <CR><C-r><C-w><CR>
nnoremap  <Space>up  :<C-u>Unite buffer file_rec/async:!<CR>

let g:unite_enable_start_insert = 1

let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup'
let g:unite_source_grep_recursive_opt = ''

autocmd MyAutoCmd FileType unite imap <buffer> <C-g>  <Plug>(unite_exit)
            \ | nmap <buffer> <C-g>  <Plug>(unite_exit)
" 2}}}
" YouCompleteMe  "{{{2
autocmd MyAutoCmd FileType c,cpp
            \   nnoremap <buffer> <Leader>pg  :<C-u>YcmCompleter GoToDefinitionElseDeclaration<CR>

let g:ycm_global_ycm_extra_conf = s:env.path.user . 'ycm_default/ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_show_diagnostics_ui = 0
let g:ycm_min_num_identifier_candidate_chars = 4
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_semantic_triggers = {'haskell' : ['.'], 'rust' : ['.', '::']}
let g:ycm_rust_src_path = s:env.language.rust.src
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
            \   'cpp' : {
            \       'type' : 'cpp/clang++',
            \       'command' : s:env.language.cpp.compiler,
            \       'cmdopt' : '-std=c++14'
            \   },
            \   'tex' : {
            \       'command' : 'latexmk',
            \       'cmdopt' : '-pv',
            \       'exec' : '%c %o %s',
            \       'outputter/error/success' : 'null'
            \   }
            \ }
" 2}}}
" 1}}}

if filereadable(s:env.path.local_vimrc)
    source `=s:env.path.local_vimrc`
endif

set secure

" vim: ft=vim fdm=marker

