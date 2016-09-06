# remove the greeting message
set fish_greeting

# local
set -gx PATH $HOME/local/bin $PATH

# cabal
if command --search cabal > /dev/null
    set -gx PATH $HOME/.cabal/bin $PATH
end

# OPAM
if command --search opam > /dev/null
    source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
end

# golang
set -gx GOPATH $HOME/.go
set -gx PATH $GOPATH/bin $PATH

# cargo
if command --search cargo > /dev/null
    set -gx PATH $HOME/.cargo/bin $PATH
end

switch (uname)
case Linux
    set -gx PATH /sbin /usr/sbin $PATH
    set -gx PATH $HOME/.gem/ruby/2.1.0/bin $PATH

    # Java
    set -gx _JAVA_OPTIONS -Dawt.useSystemAAFontSettings=lcd -Dswing.aatext=true -Dsun.java2d.xrender=true
    set -gx _JAVA_AWT_WM_NONREPARENTING 1

    # alias
    alias ls='ls --color -F'
    alias vi='vim -u ~/.vim/vimrc -N'
    alias vim='vim -u ~/.vim/vimrc -N'
    alias gvim='gvim -u ~/.vim/vimrc -U ~/.vim/gvimrc -N'

case Darwin
    # homebrew
    set -gx PATH /usr/local/bin /usr/local/sbin $PATH

    # mactex
    set -gx PATH /Library/TeX/texbin $PATH

    # rbenv
    if command --search rbenv > /dev/null
        rbenv init - --no-rehash | source
        set -gx PATH $HOME/.rbenv/shims $PATH
    end

    # alias
    alias ls='ls -GF'
    alias vim='/Applications/MacVim.app/Contents/MacOS/Vim $argv -u ~/.vim/vimrc -N'
    alias gvim='/usr/local/bin/mvim -u ~/.vim/vimrc -U ~/.vim/gvimrc -N'
    alias mvim='/usr/local/bin/mvim -u ~/.vim/vimrc -U ~/.vim/gvimrc -N'
    alias emacs='/usr/local/bin/emacs'
    alias vi='/Applications/MacVim.app/Contents/MacOS/Vim $argv -u ~/.vim/vimrc -N'

end
