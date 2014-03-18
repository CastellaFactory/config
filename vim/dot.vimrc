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

language message C
language time C

let g:is_darwin_p = has('mac') || has('macunix')
let g:is_linux_p = !g:is_darwin_p && has('unix')

function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
" 2}}}
" Options " {{{2
if has('gui_running')
    " this flag must be added before 'syntax enable' or 'filetype on' in vimrc
    set guioptions+=M
endif

syntax enable
if !exists('g:color_names')
    let g:mycolor_termtrans = (g:is_linux_p && !g:is_darwin_p) ? 1 : 0
    colorscheme mycolor
    set background=dark
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
scriptencoding utf-8
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
set list
set listchars=tab:»\ ,trail:_
if g:is_darwin_p
    set macmeta
endif
set mouse=a
set noerrorbells
set nrformats-=octal
set number
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
set ttimeoutlen=50
set t_vb=
set termencoding=utf-8
set ttyfast
set undodir=~/.vim/undo
set undofile
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
" Objmap - wrapper for textobj mapping  " {{{2
command! -nargs=+ Objmap execute 'omap' <q-args> | execute 'vmap' <q-args>

command! -nargs=+ Objnoremap execute 'onoremap' <q-args> | execute 'vnoremap' <q-args>

command! -nargs=+ Objunmap execute 'ounmap' <q-args> | execute 'vunmap' <q-args>
" 2}}}
function! s:cd_to_current_buffer_dir()  " {{{2
    lcd %:p:h
    pwd
endfunction  " 2}}}
function! s:cd_to_git_root_dir()  " {{{2
    if (system('git rev-parse --is-inside-work-tree') =~# '\<true')
        execute 'lcd ' . system('git rev-parse --show-toplevel')
    endif
    pwd
endfunction  " 2}}}
function! s:set_indent()  " {{{2
    setlocal tabstop=4 shiftwidth=4 softtabstop=4
endfunction  " 2}}}
function! s:set_short_indent()  " {{{2
    setlocal tabstop=2 shiftwidth=2 softtabstop=2
endfunction  " 2}}}
function! s:toggle_fullscreen()  " {{{2
    if g:is_darwin_p
        setlocal fullscreen! fullscreen?
    elseif g:is_linux_p
        if executable('xdotool')
            call system('xdotool key super+ctrl+l')
        else
            echo 'xdotool is not installed. you can togle fullscreen by super+f if in xmonad.'
        endif
    endif
endfunction  " 2}}}
" 1}}}

" Mappings  " {{{1
" absolute  " {{{2
" swap colon and semicolon
noremap ; :
noremap : ;

" edit vimrc and reload (don't use $MYVIMRC)
nnoremap <Space>.   :<C-u>edit ~/repo/config/vim/dot.vimrc<CR>
nnoremap <Space>t.  :<C-u>tabnew ~/repo/config/vim/dot.vimrc<CR>
nnoremap <Space>s.  :<C-u>source ~/repo/config/vim/dot.vimrc<CR>
" 2}}}
" help  " {{{2
nnoremap <C-h>  :<C-u>help<Space>
nnoremap ,h :<C-u>help<Space><C-r><C-w><CR>

" disable F1
noremap <F1> <Nop>
inoremap <F1> <Nop>
" 2}}}
" <Space> stuffs  " {{{2
nnoremap <silent> <Space>ow  :<C-u>setlocal wrap! wrap?<CR>
nnoremap <silent> <Space>of  :<C-u>call <SID>toggle_fullscreen()<CR>
nnoremap <Space>r   :<C-u>registers<CR>
nnoremap <silent> <Space>/   :<C-u>nohlsearch<CR>
nnoremap <Space>v   zMzv
" 2}}}
" movement in Insert mode  " {{{2
inoremap <C-a>  <Home>
inoremap <expr> <C-e> pumvisible() ? "\<C-e>" : "\<End>"
inoremap <C-d>  <Del>
" 2}}}
" Command-line mode  " {{{2
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
" 2}}}
" misc  " {{{2
" select last changed text (like gv p.146)
nnoremap gc `[v`]
Objnoremap gc :<C-u>normal gc<CR>

nnoremap <silent> <Space>cd     :<C-u>call <SID>cd_to_current_buffer_dir()<CR>
nnoremap <silent> <Space>cgd    :<C-u>call <SID>cd_to_git_root_dir()<CR>

" disable dangerous command
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" disable EX-mode
nnoremap Q q
nnoremap q <Nop>
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
NeoBundle 'Shougo/vimproc.vim', {
            \   'build' : {
            \       'mac' : 'make -f make_mac.mak',
            \       'unix' : 'make -f make_unix.mak'} }
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-fugitive'
NeoBundleLazy 'dag/vim2hs', {
            \   'autoload' : {'filetypes' : ['haskell']} }
NeoBundleLazy 'eagletmt/ghcmod-vim', {
            \   'autoload' : {'filetypes' : ['haskell']} }
NeoBundleLazy 'eagletmt/neco-ghc', {
            \   'autoload' : {'filetypes' : ['haskell']} }
NeoBundleLazy 'eagletmt/unite-haddock', {
            \   'autoload' : {'unite_sources' : 'haddock'} }
NeoBundleLazy 'junegunn/vim-easy-align', {
            \   'autoload' : {'mappings' : ['<Plug>(EasyAlign)']} }
NeoBundleLazy 'kana/vim-altr', {
            \   'autoload' : {'mappings' : ['<Plug>(altr-']} }
NeoBundleLazy 'kana/vim-filetype-haskell', {
            \   'autoload' : {'filetypes' : ['haskell']} }
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
NeoBundleLazy 'kana/vim-fakeclip', { 'autoload' : {'terminal' : 1} }
NeoBundleLazy 'rhysd/vim-clang-format', {
            \   'autoload' : {'mappings' : ['<Plug>(operator-clang-format)']} }
NeoBundleLazy 'rhysd/vim-operator-surround', {
            \   'autoload' : {'mappings' : ['<Plug>(operator-surround-']} }
NeoBundleLazy 'scrooloose/syntastic', {
            \   'autoload' : {'commands' : ['SyntasticCheck']} }
NeoBundleLazy 'Shougo/unite.vim', {
            \   'autoload' : {'commands' : [{'name' : 'Unite', 'complete' : 'customlist,unite#complete_sources'}]}}
NeoBundleLazy 'Shougo/unite-outline', {
            \   'autoload' : {'unite_sources' : 'outline'} }
NeoBundleLazy 'Shougo/vimfiler.vim', {
            \   'autoload' : {'commands' : ['VimFiler', 'VimFilerCurrentDir', 'VimFilerBufferDir',
            \                               'VimFilerSplit', 'VimFilerExplorer', 'VimFilerDouble']} }
NeoBundleLazy 'SirVer/ultisnips', {'autoload' : {'functions' : ['UltiSnips#FileTypeChanged']}}
NeoBundleLazy 'tyru/caw.vim', {
            \   'autoload' : {'mappings' : ['<Plug>(caw:']} }
NeoBundleLazy 'ujihisa/unite-haskellimport', {
            \   'autoload' : {'unite_sources' : 'haskellimport'} }
NeoBundleLazy 'Valloric/YouCompleteMe', {
            \   'build' : {
            \       'unix' : 'git submodule update --init --recursive && ./install.sh --clang-completer --system-libclang',
            \       'mac' : 'git submodule update --init --recursive && ./install.sh --clang-completer'},
            \   'autoload' : {'insert' : 1, 'commands' : ['YcmCompleter']},
            \   'augroup' : 'youcompletemeStart'}
NeoBundleLazy 'vim-jp/cpp-vim', {
            \   'autoload' : {'filetypes' : ['cpp']} }
NeoBundleFetch 'Lokaltog/powerline'

filetype plugin indent on
NeoBundleCheck
" 2}}}
" 1}}}

" FileTypes  "{{{1
" additional settings(e.g. expandtab,omnifunc) are in ~/.vim/after/ftplugin
" All filetypes  " {{{2
set formatoptions-=ro    " this flag shoud be set after 'filetype on'
autocmd MyAutoCmd FileType * call s:on_Filetype_Any()
function! s:on_Filetype_Any()
    setlocal formatoptions-=ro
    if &l:omnifunc == ''
        setlocal omnifunc=syntaxcomplete#Complete
    endif
endfunction

autocmd MyAutoCmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
" 2}}}
autocmd MyAutoCmd FileType c,cpp,python,vim call s:set_indent()
autocmd MyAutoCmd FileType ruby,haskell call s:set_short_indent()
" 1}}}

" Plugins {{{1
" altr  " {{{2
nmap <F3> <Plug>(altr-forward)
nmap <F2> <Plug>(altr-back)

let s:bundle = neobundle#get('vim-altr')
function! s:bundle.hooks.on_source(bundle)
    " vimrc and gvimrc
    call altr#define('vimrc', 'gvimrc', 'vimrc_practice')
endfunction
unlet s:bundle
" 2}}}
" caw  " {{{2
let g:caw_no_default_keymappings = 1
let g:caw_i_sp_blank = ' '

nmap cci <Plug>(caw:i:comment)
nmap cca <Plug>(caw:a:comment)
nmap cco <Plug>(caw:jump:comment-next)
nmap ccO <Plug>(caw:jump:comment-prev)
nmap <Leader>cc <Plug>(caw:i:toggle)
vmap <Leader>cc <Plug>(caw:i:toggle)
nmap <Leader>ca <Plug>(caw:a:toggle)
nmap <Leader>cw <Plug>(caw:wrap:toggle)
" 2}}}
" easy-align  " {{{2
map <Leader>a <Plug>(EasyAlign)
" 2}}}
" fugitive  " {{{2
nnoremap <Leader>gs :<C-u>Gstatus<CR>
nnoremap <Leader>gc :<C-u>Gcommit -v<CR>
nnoremap <Leader>gC :<C-u>Gcommit<CR>
nnoremap <Leader>ga :<C-u>Gwrite<CR>
nnoremap <Leader>gd :<C-u>Gdiff<CR>
nnoremap <Leader>gb :<C-u>Gblame<CR>
nnoremap <Leader>gp :<C-u>Git push<CR>
nnoremap <Leader>gP :<C-u>Git pull<CR>
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
" clang-format  " {{{3
autocmd MyAutoCmd FileType cpp map <buffer> <Leader>x <Plug>(operator-clang-format)

let s:bundle = neobundle#get('vim-clang-format')
function! s:bundle.hooks.on_source(bundle)
    " Mac: homebrew
    " Linux: build from source and make symbolic link
    let g:clang_format#command = 'clang-format-3.5'
    let g:clang_format#code_style = 'LLVM'
    let g:clang_format#style_options = {
                \   'AccessModifierOffset' : -4,
                \   'AllowShortIfStatementsOnASingleLine' : 'true',
                \   'AllowShortFunctionsOnASingleLine' : 'true',
                \   'AlwaysBreakTemplateDeclarations' : 'true',
                \   'Standard' : 'Cpp11',
                \   'PointerBindsToType' : 'true',
                \   'BreakBeforeBraces' : 'Stroustrup',
                \   'IndentWidth' : 4,
                \   'TabWidth' : 4,
                \   'UseTab' : 'ForIndentation',
                \ }
endfunction
unlet s:bundle
" 3}}}
" operator-surround  {{{3
map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sr <Plug>(operator-surround-replace)
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
function! s:bundle.hooks.on_source(bundle)
    call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
    call smartinput#map_to_trigger('i', '<BS>', '<BS>', '<BS>')
    call smartinput#map_to_trigger('i', '<CR>', '<CR>', '<CR>')

    " delete trailing spaces
    call smartinput#define_rule({
                \   'at' : '\s\+\%#',
                \   'char' : '<CR>',
                \   'input' : "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', '')) <Bar> echo 'delete trailing spaces'<CR><CR>",
                \ })
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
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_enable_highlighting = 0
let g:syntastic_check_on_wq = 0
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
" 2}}}
" UltiSnips  "{{{2
let g:UltiSnipsSnippetDirectories = ['ultisnips-snippets']
let g:UltiSnipsExpandTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<C-k>'
let g:UltiSnipsJumpBackwardTrigger = '<M-k>'
let g:UltiSnipsListSnippets = '<M-Tab>'
let g:snips_author = 'Castella'
" とりあえず様子見
augroup UltiSnipsWorkaround
    autocmd!
    if !neobundle#is_sourced('ultisnips')
        autocmd FileType * call UltiSnips#FileTypeChanged()
    endif
augroup END
let s:bundle = neobundle#get('ultisnips')
function! s:bundle.hooks.on_post_source(bundle)
    autocmd! UltiSnipsWorkaround
endfunction
unlet s:bundle
" 2}}}
" unite  " {{{2
nnoremap <Space>ub  :<C-u>Unite buffer_tab<CR>
nnoremap <Space>ut  :<C-u>Unite tab<CR>
nnoremap <Space>ufr :<C-u>Unite file_mru<CR>
nnoremap <Space>udr :<C-u>Unite directory_mru<CR>
nnoremap <Space>urm :<C-u>UniteResume<CR>
nnoremap <Space>uff :<C-u>Unite file<CR>
nnoremap <Space>uol :<C-u>Unite outline<CR>
nnoremap <Space>unnb    :<C-u>Unite neobundle<CR>
" grep
nnoremap <Space>ug  :<C-u>Unite grep:. <CR>
nnoremap ,g :<C-u>Unite grep:. <CR><C-r><C-w><CR>

nnoremap  <Space>up :<C-u>Unite buffer file_rec/async:!<CR>

" close unite buffer
autocmd MyAutoCmd FileType unite imap <buffer><C-g> <Plug>(unite_exit)
autocmd MyAutoCmd FileType unite nmap <buffer><C-g> <Plug>(unite_exit)

let g:unite_enable_start_insert = 1
let g:unite_force_overwrite_statusline = 0

" unite-grep(the_silver_searcher)
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup'
let g:unite_source_grep_recursive_opt = ''
" 2}}}
" vim2hs  "{{{2
let g:haskell_conceal = 0
let g:haskell_conceal_enumerations = 0
" 2}}}
" vimfiler  " {{{2
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_force_overwrite_statusline = 0

nnoremap <Space>fc  :<C-u>VimFilerCurrentDir<CR>
nnoremap <Space>fb  :<C-u>VimFilerBufferDir<CR>
" 2}}}
" YouCompleteMe  "{{{2
let s:bundle = neobundle#get('YouCompleteMe')
function! s:bundle.hooks.on_source(bundle)
    let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_default/ycm_extra_conf.py'
    let g:ycm_show_diagnostics_ui = 0
    let g:ycm_autoclose_preview_window_after_completion = 1
    let g:ycm_min_num_identifier_candidate_chars = 4
    let g:ycm_seed_identifiers_with_syntax = 1
    " add semantic triggers
    let g:ycm_semantic_triggers = {
                \   'haskell' : ['.']
                \ }
endfunction
unlet s:bundle

autocmd MyAutoCmd FileType c,cpp nnoremap <buffer> <Leader>pg :<C-u>YcmCompleter GoToDefinitionElseDeclaration<CR>
autocmd MyAutoCmd FileType c,cpp nnoremap <buffer> <Leader>pd :<C-u>YcmCompleter GoToDefinition<CR>
autocmd MyAutoCmd FileType c,cpp nnoremap <buffer> <Leader>pc :<C-u>YcmCompleter GoToDeclaration<CR>
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

autocmd MyAutoCmd FileType c nnoremap <buffer> <Leader>R :<C-u>QuickRun c_compile<CR>
autocmd MyAutoCmd FileType cpp nnoremap <buffer> <Leader>R :<C-u>QuickRun cpp_compile<CR>
autocmd MyAutoCmd FileType haskell nnoremap <buffer> <Leader>R :<C-u>QuickRun haskell_compile<CR>
" 2}}}
" 1}}}

set secure

" vim: ft=vim fdm=marker

