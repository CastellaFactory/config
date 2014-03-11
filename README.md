config
======

My configuration files

======
# zsh
### login shell  
system zshenv --> $ZDOTDIR/.zshenv --> system zprofile --> $ZDOTDIR/.zprofile --> system zshrc --> $ZDOTDIR/.zshrc --> system zlogin --> $ZDOTDIR/.zlogin
$ZDOTDIR : ~ (before $ZDOTDIR/.zshenv)
$ZDOTDIR : ~/.zsh (after $ZDOTDIR/.zshenv)
### interactive shell  
system zshenv --> $ZDOTDIR/.zshenv --> system zshrc --> $ZDOTDIR/.zshrc
### none interactive shell  
system zshenv --> $ZDOTDIR/.zshenv
