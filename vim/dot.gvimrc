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

if g:is_darwin_p
    " default: egmrL
    set guioptions-=e
    set guioptions-=g
    set guioptions-=m
    set guioptions-=r
    set guioptions-=L
    set guioptions+=i
    set guioptions+=M

    " set guifont=RictyForPowerline-Bold:h18
    set guifont=Menlo-Bold:h16
    set transparency=10

elseif g:is_linux_p
    " default: aegimrLtT
    set guioptions-=a
    set guioptions-=e
    set guioptions-=g
    set guioptions-=m
    set guioptions-=r
    set guioptions-=L
    set guioptions-=t
    set guioptions-=T
    set guioptions+=M

    " set guifont=Ricty\ for\ Powerline\ Bold\ 14
    set guifont=Menlo\ bold\ 13
    set guifontwide=Hiragino\ Kaku\ Gothic\ Pro\ Bold\ 12

endif
colorscheme iceberg

