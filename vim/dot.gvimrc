"   ____       _
"  / ___|_   _(_)_ __ ___  _ __ ___
" | |  _\ \ / / | '_ ` _ \| '__/ __|
" | |_| |\ V /| | | | | | | | | (__
"  \____| \_/ |_|_| |_| |_|_|  \___|
"
"
"

" see :help visualbell
set t_vb=

set guioptions-=e
set guioptions-=g
set guioptions-=m
set guioptions-=r
set guioptions-=L
set guioptions+=c

if g:is_darwin_p
    " default guioptions: egmrL
    set guifont=Meslo\ LG\ M\ bold:h16
    set transparency=10

elseif g:is_linux_p
    " default guioptions: aegimrLtT
    set guioptions-=a
    set guioptions-=i
    set guioptions-=t
    set guioptions-=T

    set guifont=源ノ角ゴシック\ Code\ JP\ Bold\ 11
    if filereadable(expand('~/.vim/local.gvimrc'))
        source ~/.vim/local.gvimrc
    endif
endif
