# Aliases  # {{{1
alias gpp='g++'
alias e='emacsclient -a'
alias et='emacsclient -t'
alias ec='emacsclient -c -n'
alias ke="emacsclient -e '(kill-emacs)'"
alias se='emacs --daemon'
alias gosh='rlwrap gosh'
alias sml='rlwrap sml'
alias ocaml='rlwrap ocaml'
# 1}}}

# Options  # {{{1
setopt always_last_prompt
setopt auto_cd
setopt auto_list
setopt auto_menu
setopt auto_param_keys
setopt auto_param_slash
setopt bang_hist
setopt correct
setopt globdots
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt list_packed
setopt list_types
setopt magic_equal_subst
setopt no_beep
setopt prompt_subst
setopt share_history
# 1}}}

# History  # {{{1
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=10000
# don't add 'rm' and 'rmdir'
zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}

    [[ $cmd != rm(|dir) ]]
}
# cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 100
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both
# 1}}}

# Prompt  # {{{1
autoload colors && colors
local LEFTC=$'%{\e[0;33m%}'
PROMPT='$LEFTC${USER}@${HOST} %F{White}%~%(!.#.$)%f '
# 1}}}

# Completion  # {{{1
autoload -U compinit && compinit -C
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:options' description 'yes'
# 1}}}

# misc  # {{{1
bindkey -e

# remove duplicates from path
typeset -U path cdpath fpath manpath

if [ -n "$TMUX" ]; then
    # for vim background color isuue in tmux?
    export TERM=screen-256color
else
    export TERM=xterm-256color
fi
# 1}}}

# Plugins  # {{{1
# 1}}}

# peco  # {{{1
# select-history  # {{{2
function peco-select_history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select_history
# 2}}}
# cdr  # {{{2
function peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr
# 2}}}
# dir_find  # {{{2
function peco-dir_find() {
    local current_buffer=$BUFFER
    local selected_dir="$(find . -maxdepth 5 -type d ! -path "*/.*"| peco)"
    if [ -d "$selected_dir" ]; then
        BUFFER="${current_buffer} \"${selected_dir}\""
        CURSOR=$#BUFFER
        # zle accept-line
    fi
    zle clear-screen
}
zle -N peco-dir_find
# 2}}}
# ghq  # {{{2
function peco-ghq() {
    local selected_dir=$(ghq list | peco --prompt 'ghq >' --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        local ghq_root=$(git config ghq.root)
        if [[ "$ghq_root" != "" ]] then
            BUFFER="cd ${ghq_root}/${selected_dir}"
            zle accept-line
        else
            echo "Set ghq root."
        fi
    fi
    zle clear-screen
}
zle -N peco-ghq

function peco-ghq_open() {
    local open
    case $OSTYPE in
    darwin*)
        open="open"
        ;;
    linux*)
        open="xdg-open"
        ;;
    esac

    local selected_repo=$(ghq list | peco --prompt 'ghq-open >' --query "$LBUFFER")
    if [ -n "$selected_repo" ]; then
        $open "https://${selected_repo}"
    fi
    zle clear-screen
}
zle -N peco-ghq_open
# 2}}}

bindkey '^r' peco-select_history
bindkey '^@' peco-cdr
bindkey '^x^f' peco-dir_find
bindkey '^g' peco-ghq
bindkey '^o' peco-ghq_open
# 1}}}

# OS specific settings  # {{{1
case "${OSTYPE}" in
    darwin*)
        source $HOME/.zshrc.mac
        ;;

    linux*)
        source $HOME/.zshrc.linux
        ;;
esac
# 1}}}

# vim: ft=zsh
