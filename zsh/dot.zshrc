#
# $TERM
#

export TERM=xterm-256color

#
# prompt
#
autoload colors && colors
setopt prompt_subst
local LEFTC=$'%{\e[0;33m%}'
PROMPT='$LEFTC${USER}@${HOST} %F{White}%~%(!.#.$)%f '

#
# aliases
#
alias gpp='g++'
alias e='emacsclient -a'
alias et='emacsclient -t'
alias ec='emacsclient -c -n'
alias ke="emacsclient -e '(kill-emacs)'"
alias se='emacs --daemon'

#
# basic settings
#
bindkey -e					# Emacs like
setopt auto_cd				# ディレクトリ名の入力のみで移動
setopt correct				# コマンドのスペルを訂正
setopt magic_equal_subst	# =以降も補完する(--prefix=/usrなど)
setopt no_beep				# disabel beep

# 重複パスを登録しない
typeset -U path cdpath fpath manpath


#
# completions
#
autoload -U compinit && compinit	# 補完機能
setopt always_last_prompt			# カーソル位置を保持してファイル名一覧を補完
setopt auto_list					# 補完候補を一覧で表示
setopt auto_menu					# 補完キー連打で補完候補を順に表示
setopt auto_param_slash				# 補完候補がディレクトリの場合, 末尾に / を追加
setopt auto_param_keys				# カッコの対応を補完
setopt globdots						# 明確なドットの指定なしで.から始まるファイルをマッチ
setopt list_packed					# 補完候補をできるだけ詰めて表示
setopt list_types					# 補完候補にファイルの種類も表示
setopt list_types					# 補完候補一覧でファイルの種別を識別マーク表示

zstyle ':completion:*:default' menu select=2			#補完候補を矢印キーで選択可能に
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'		# 補完時に大文字小文字を区別しない
# separator
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

# LS_COLORSを設定
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 補完関数の表示
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''


#
# history
#
HISTFILE=~/.zsh_history			# ヒストリを保存するファイル
HISTSIZE=1000					# メモリに保存されるヒストリの件数
SAVEHIST=1000					# 保存されるヒストリの件数
setopt bang_hist				# !を使ったヒストリ展開
setopt hist_ignore_all_dups		# 重複ヒストリを保持しない(古い方を削除)
setopt hist_ignore_dups			# 直前と同じコマンドはヒストリに追加しない
setopt hist_reduce_blanks		# 余分なスペースを削除してヒストリに保存
setopt share_history			# 他のシェルのヒストリをリアルタイムで共有

# マッチしたコマンドのヒストリを表示
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end


#
# plugins
#

# zaw
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 1000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

source $ZPLUGINDIR/zaw/zaw.zsh
zstyle ':filter-select' case-insensitive yes	# case-insensitive
bindkey '^@' zaw-cdr							# <C-@>


#
# functions
#

function zsh-plugin-update() {
	local cwd
	cwd=$PWD
	for plugin in `ls $ZPLUGINDIR`; do
		cd $ZPLUGINDIR/$plugin
		git pull
		cd ..
	done
	cd $cwd
}


#
# OS specific settings
#

case "${OSTYPE}" in
	darwin*)
		source $ZDOTDIR/.zshrc.mac
		;;

	linux*)
		source $ZDOTDIR/.zshrc.linux
		;;
esac

# vim: ft=zsh
