" __      ___
" \ \    / (_)
"  \ \  / / _ _ __ ___  _ __ ___
"   \ \/ / | | '_ ` _ \| '__/ __|
"    \  /  | | | | | | | | | (__
"     \/   |_|_| |_| |_|_|  \___|
"
"

" NeoBundle  " {{{1
" Base  " {{{2
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

let g:neobundle#install_process_timeout = 2000

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'
" 2}}}
" Utilities  " {{{2
NeoBundle 'Shougo/vimproc.vim', {
            \   'build' : {
            \       'mac' : 'make -f make_mac.mak',
            \       'unix' : 'make -f make_unix.mak'} }
NeoBundleLazy 'kana/vim-altr', {
            \   'autoload' : {'mappings' : ['<Plug>(altr-']} }
NeoBundle 'kana/vim-submode'
NeoBundleLazy 'kana/vim-fakeclip', { 'autoload' : {'terminal' : 1} }
" 2}}}
" Filer  " {{{2
NeoBundleLazy 'Shougo/vimfiler.vim', {
            \   'autoload' : {'commands' : ['VimFiler', 'VimFilerCurrentDir', 'VimFilerBufferDir',
            \                               'VimFilerSplit', 'VimFilerExplorer', 'VimFilerDouble']} }
" 2}}}
" Completion  " {{{2
NeoBundleLazy 'Valloric/YouCompleteMe', {
            \   'build' : {
            \       'unix' : 'git submodule update --init --recursive && ./install.sh --clang-completer --system-libclang',
            \       'mac' : 'git submodule update --init --recursive && ./install.sh --clang-completer'},
            \   'autoload' : {'insert' : 1, 'commands' : ['YcmCompleter']},
            \   'augroup' : 'youcompletemeStart'}
NeoBundleLazy 'SirVer/ultisnips', {'autoload' : {'functions' : ['UltiSnips#FileTypeChanged']}}
NeoBundleLazy 'eagletmt/neco-ghc', {
            \   'autoload' : {'filetypes' : ['haskell']} }
" 2}}}
" Unite  " {{{2
NeoBundleLazy 'Shougo/unite.vim', {
            \   'autoload' : {'commands' : [{'name' : 'Unite', 'complete' : 'customlist,unite#complete_sources'}]}}
NeoBundle 'Shougo/neomru.vim'
NeoBundleLazy 'Shougo/unite-outline', {
            \   'autoload' : {'unite_sources' : 'outline'} }
NeoBundleLazy 'eagletmt/unite-haddock', {
            \   'autoload' : {'unite_sources' : 'haddock'} }
NeoBundleLazy 'ujihisa/unite-haskellimport', {
            \   'autoload' : {'unite_sources' : 'haskellimport'} }
" 2}}}
" Textobj  " {{{2
NeoBundle 'kana/vim-textobj-user'
NeoBundleLazy 'kana/vim-textobj-entire', {
            \   'autoload' : {'mappings' : [ ['xo', 'ae'], ['xo', 'ie'] ]} }
NeoBundleLazy 'kana/vim-textobj-line', {
            \   'autoload' : {'mappings' : [ ['xo', 'al'], ['xo', 'il'] ]} }
NeoBundleLazy 'kana/vim-textobj-function', {
            \   'autoload' : {'mappings' : [ ['xo', 'af'], ['xo', 'if'] ]} }
NeoBundleLazy 'kana/vim-textobj-indent', {
            \   'autoload' : {'mappings' : [ ['xo', 'ii'], ['xo', 'ai'], ['xo', 'iI'], ['xo', 'aI'] ]} }
" 2}}}
" Operator  " {{{2
NeoBundle 'kana/vim-operator-user'
NeoBundleLazy 'rhysd/vim-clang-format', {
            \   'autoload' : {'mappings' : ['<Plug>(operator-clang-format)']} }
" 2}}}
" Editing  " {{{2
NeoBundleLazy 'tyru/caw.vim', {
            \   'autoload' : {'mappings' : ['<Plug>(caw:']} }
NeoBundleLazy 'kana/vim-smartinput', { 'autoload' : {'insert' : 1} }
NeoBundleLazy 'junegunn/vim-easy-align', {
            \   'autoload' : {'mappings' : ['<Plug>(EasyAlign)']} }
" 2}}}
" Quickrun  " {{{2
NeoBundle 'thinca/vim-quickrun'
" 2}}}
" Filetype  " {{{2
" C/C++
NeoBundleLazy 'vim-jp/cpp-vim', {
            \   'autoload' : {'filetypes' : ['cpp']} }
" Haskell
NeoBundleLazy 'kana/vim-filetype-haskell', {
            \   'autoload' : {'filetypes' : ['haskell']} }
NeoBundleLazy 'eagletmt/ghcmod-vim', {
            \   'autoload' : {'filetypes' : ['haskell']} }
NeoBundleLazy 'dag/vim2hs', {
            \   'autoload' : {'filetypes' : ['haskell']} }
" 2}}}
" Syntax Check  " {{{2
NeoBundleLazy 'scrooloose/syntastic', {
            \   'autoload' : {'commands' : ['SyntasticCheck']} }
" 2}}}
" UI  " {{{2
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'chriskempson/base16-vim'
NeoBundle 'cocopon/iceberg.vim'
" 2}}}
" Vcs  " {{{2
NeoBundle 'tpope/vim-fugitive'
" 2}}}
" Doc  " {{{2
NeoBundle 'vim-jp/vimdoc-ja'
" 2}}}
" Others(fetch only)  " {{{2
NeoBundleFetch 'chriskempson/base16-shell'
NeoBundleFetch 'chriskempson/base16-xresources'
NeoBundleFetch 'chriskempson/base16-iterm2'
NeoBundleFetch 'Lokaltog/powerline'
" 2}}}"

filetype plugin indent on
" Installation Check.
NeoBundleCheck
" 1}}}

" Basic Settings  " {{{1
" Base  " {{{2
augroup MyAutoCmd
    autocmd!
augroup END

language message C
language time C

" help language
set helplang=en,ja

let g:is_darwin_p = has('mac') || has('macunix')
let g:is_linux_p = !g:is_darwin_p && has('unix')

" 2}}}
" Edit  " {{{2
" encoding
set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932

" tab settings
set softtabstop=4
set shiftwidth=4
set tabstop=4
set autoindent
set smarttab
set shiftround
set noexpandtab

" comment
autocmd MyAutoCmd Filetype * setlocal formatoptions-=ro

" move bol<->eol
set whichwrap=b,s,h,l,[,],<,>,~

" autoreload
set autoread

" enable backspace delete indent eol newline
set backspace=indent,eol,start
" 2}}}
" Search & Replace  " {{{2
set incsearch
set ignorecase
set smartcase
set wrapscan
set hlsearch
nohlsearch
" 2}}}
" Appearance  " {{{2
" disable startup message
set shortmess=aoOIt
" show match paren
set showmatch
" open new window into bottom
set splitbelow splitright

set nrformats-=octal

" cursorline
set cursorline

" show line number
set number
set ruler

set wrap

set ambiwidth=double

" always show statusline
set laststatus=2
set cmdheight=2
set showcmd

" always show tabline
set showtabline=2

" command line
set wildmenu
set wildchar=<TAB>
set wildmode=longest:full,full

set list
set listchars=tab:»\ ,trail:_

" set tabline  " {{{3
function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
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
" 3}}}
" 2}}}
" Other  " {{{2
" disable bell
set visualbell
set t_vb=
set noerrorbells

if g:is_darwin_p
    set macmeta
endif

" clipboard
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
else
    set clipboard=unnamed
endif

" completion
set completeopt=menuone

set history=100

" enable mouse
set mouse=a

set scrolloff=3
set sidescrolloff=5
set sidescroll=1

set ttyfast

" enable folding
set foldenable
set foldmethod=marker

" backup directory
set directory=~/.vim/backups
set backupdir=~/.vim/backups

" undo
set undofile
set undodir=~/.vim/undo

" goto last changed place
autocmd MyAutoCmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" とりあえず作ってみたので試験運用
function! CD_test()
    execute 'lcd ' . fnameescape(expand('%:p:h'))
    if (system('git rev-parse --is-inside-work-tree') ==# 'true\n')
        execute 'lcd ' . fnameescape(system('git rev-parse --show-toplevel'))
    endif
    pwd
endfunction
nnoremap <silent> <Space>cd  :<C-u>call CD_test()<CR>
" 2}}}
" 1}}}

" Mappings  " {{{1
" show list of all mappnig
" :Allmaps
" :verbose Allmaps <buffer>
command!
            \   -nargs=* -complete=mapping
            \   AllMaps
            \   map <args> | map! <args> | lmap <args>
" Normal-mode keymapping " {{{2

" quick help
nnoremap <C-h>  :<C-u>help<Space>
nnoremap ,h :<C-u>help<Space><C-r><C-w><CR>
" to avoid gobaku
nnoremap <F1> <Nop>

" toggle wrap
nnoremap <Space>ow
            \  :<C-u>setlocal wrap!
            \ \|     setlocal wrap?<CR>

" disable dangerous command
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" macro
" disable EX-mode
nnoremap Q q
nnoremap q <Nop>

" linux only
if g:is_linux_p
    nnoremap ; :
    nnoremap : ;
endif

" edit vimrc and reload (don't use $MYVIMRC)
nnoremap <Space>.   :<C-u>edit ~/repo/config/vim/dot.vimrc<CR>
nnoremap <Space>t.  :<C-u>tabnew ~/repo/config/vim/dot.vimrc<CR>
nnoremap <Space>s.  :<C-u>source ~/repo/config/vim/dot.vimrc<CR>
" 2}}}
" Insert-mode keymapping  " {{{2
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Del>
" 2}}}
" Command-mode keymapping  " {{{2
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" escape /
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
" 2}}}
" 1}}}

" Plugin Settings " {{{1
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

nmap gci <Plug>(caw:i:comment)
nmap gca <Plug>(caw:a:comment)
nmap gco <Plug>(caw:jump:comment-next)
nmap gcO <Plug>(caw:jump:comment-prev)
nmap <Leader>cc <Plug>(caw:i:toggle)
vmap <Leader>cc <Plug>(caw:i:toggle)
nmap <Leader>ca <Plug>(caw:a:toggle)
nmap <Leader>cw <Plug>(caw:wrap:toggle)
" 2}}}
" colorsceme  " {{{2
if !has('gui_running')
    set t_Co=256
endif
set background=dark

syntax enable
"colorscheme base16-ocean
colorscheme iceberg
" }}}"
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
let g:syntastic_cppcheck_config_file = '~/.vim/syntastic_config/cppcheck'
let g:syntastic_mode_map = {'mode': 'passive'}
" C  " {{{3
let g:syntastic_c_checkers = ['gcc', 'cppcheck']
let g:syntastic_c_compier = 'clang'
let g:syntastic_c_compiler_options = '-std=c11 -Weverything -Wno-system-headers -Wno-missing-variable-declarations -Wno-missing-prototypes -fno-caret-diagnostics'
let g:syntastic_c_no_default_include_dirs = 1
let g:syntastic_c_no_include_search = 1
" 3}}}
" C++  " {{{3
let g:syntastic_cpp_checkers = ['gcc', 'cppcheck']
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++11 -Weverything -Wno-system-headers -Wno-missing-variable-declarations -Wno-c++98-compat -Wno-missing-prototypes -fno-caret-diagnostics'
let g:syntastic_cpp_no_default_include_dirs = 1
let g:syntastic_cpp_no_include_search = 1
" 3}}}
"  Haskell  " {{{3
let g:syntastic_haskell_checkers = ['ghc_mod', 'hlint']
" 3}}}
" 2}}}
" UltiSnips  "{{{2
let g:UltiSnipsSnippetDirectories = ['ultisnips-snippets']
let g:UltiSnipsExpandTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<C-k>'
let g:UltiSnipsJumpBackwardTrigger = '<M-k>'
let g:snips_author = 'Castella'
" とりあえず様子見
augroup UltiSnipsWorkaround
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
nnoremap <Space>ufm :<C-u>Unite file_mru<CR>
nnoremap <Space>udm :<C-u>Unite directory_mru<CR>
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

" vim: set ft=vim fdm=marker :

