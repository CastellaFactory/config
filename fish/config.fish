#if status --is-login
    # remove the greeting message
    set -g fish_greeting
    
    # local
    set -gx PATH ~/local/bin $PATH
    
    # cabal
    if command --search cabal > /dev/null
        set -gx PATH ~/.cabal/bin $PATH
    end
    
    # OPAM
    if command --search opam > /dev/null
        source ~/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
    end
    
    # golang
    set -gx GOPATH ~/.go
    set -gx PATH $GOPATH/bin $PATH
    
    # cargo
    if command --search cargo > /dev/null
        set -gx PATH ~/.cargo/bin $PATH
    end
    
    
    switch (uname)
    case Linux
        set -gx PATH /sbin /usr/sbin $PATH
        set -gx PATH ~/.gem/ruby/2.1.0/bin $PATH
    
        # Java
        set -gx _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true'
    
        # alias
        alias ls='ls --color -F'
        alias vi='vim -u ~/.vim/vimrc -N'
        alias vim='vim -u ~/.vim/vimrc -N'
        alias gvim='gvim -u ~/.vim/vimrc -U ~/.vim/gvimrc -N'
    
    case Darwin
        # homebrew
        set -gx PATH /usr/local/sbin $PATH
    
        # rbenv
        if command --search rbenv > /dev/null
            rbenv init - --no-rehash | source
        end
    
        # alias
        alias ls='ls -GF'
        alias vi='/Applications/MacVim.app/Contents/MacOS/Vim $argv -u ~/.vim/vimrc -N'
        alias vim='/Applications/MacVim.app/Contents/MacOS/Vim $argv -u ~/.vim/vimrc -N'
        alias gvim='/usr/local/bin/mvim -u ~/.vim/vimrc -U ~/.vim/gvimrc -N'
        alias mvim='/usr/local/bin/mvim -u ~/.vim/vimrc -U ~/.vim/gvimrc -N'
    
    end
#end

function fish_user_key_bindings
    bind \cr peco_select_history
    bind \cg peco_select_ghq_repository
end
