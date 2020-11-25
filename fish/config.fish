if status --is-login
    # remove the greeting message
    set -gx fish_greeting ''

    # local
    set -gx PATH ~/local/bin $PATH

    # Haskell Stack
    if command --search stack > /dev/null
        set -gx PATH ~/.local/bin $PATH
    end

    # Golang
    set -gx GOPATH ~/.go
    set -gx PATH $GOPATH/bin $PATH

    # Rust cargo
    set -gx PATH ~/.cargo/bin $PATH

    # Fzf
    set -gx FZF_DEFAULT_OPTS '--reverse --border'

    switch (uname)
    case Linux
        # linuxbrew
        if test -d /home/linuxbrew > /dev/null
            set -gx PATH /home/linuxbrew/.linuxbrew/bin
        end

        # alias
        alias vi='vim -u ~/.vim/vimrc -N'
        alias vim='vim -u ~/.vim/vimrc -N'
        alias gvim='gvim -u ~/.vim/vimrc -U ~/.vim/gvimrc -N'

    case Darwin
        # homebrew
        if command --search brew > /dev/null
            set -gx PATH /usr/local/sbin $PATH
            set -gx PATH $PATH /usr/local/opt/llvm/bin 
        end

        # rbenv
        if command --search rbenv > /dev/null
            rbenv init - --no-rehash | source
        end

        # alias
        alias vim='/Applications/MacVim.app/Contents/bin/vim -u ~/.vim/vimrc -N'
        alias mvim='/Applications/MacVim.app/Contents/bin/mvim  -u ~/.vim/vimrc -U ~/.vim/gvimrc -N'
    end
end

function fish_user_key_bindings
    bind \cr fzf_select_history
    bind \cg fzf_select_ghq_repository
end
