# zmodload zsh/zprof && zprof

# Golang
if test -d $HOME/go > /dev/null; then
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$PATH
fi

# Rust Cargo
if test -d $HOME/.cargo > /dev/null; then
    export PATH=$HOME/.cargo/bin:$PATH
fi

export FZF_DEFAULT_OPTS='--reverse'

case "${OSTYPE}" in
    darwin*)
        source $HOME/.zshenv.mac
        ;;

    linux*)
        source $HOME/.zshenv.linux
        ;;
esac

export PATH=$HOME/local/bin:$PATH

# vim: ft=zsh
