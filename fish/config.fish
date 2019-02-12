if status --is-login
    # remove the greeting message
    set -g fish_greeting ''

    # local
    set -gx PATH ~/local/bin $PATH

    # haskell stack
    if command --search stack > /dev/null
        set -gx PATH ~/.local/bin $PATH
    end

    # OPAM
    if command --search opam > /dev/null
        source ~/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
    end

    # golang
    set -gx GOPATH ~/.go
    set -gx PATH $GOPATH/bin $PATH

    # cargo
    set -gx PATH ~/.cargo/bin $PATH

    switch (uname)
    case Linux
        set -gx PATH $PATH /sbin /usr/sbin
        set -gx PATH ~/.gem/ruby/2.2.0/bin $PATH

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

