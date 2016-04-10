#!/bin/sh

# workaround for Qt apps under environments other than KDE
export XDG_CURRENT_DESKTOP=KDE

compton -b -C -G --config ~/.compton.conf &

(sleep 3; /usr/lib64/libexec/polkit-kde-authentication-agent-1) &
# (sleep 3; /usr/lib64/libexec/polkit-gnome-authentication-agent-1) &

(sleep 1; stalonetray) &
(sleep 1; nitrogen --restore) &
(sleep 2; kmix --keepvisibility) &
(sleep 2; fcitx) &
(sleep 3; insync start) &
(sleep 4; dropbox) &
xset -b

xrdb -merge ~/.Xresources

if [[ -e "$HOME/.xsession_local" ]]; then
    source $HOME/.xsession_local
fi

# lightdm doesn't load this
source $HOME/.zprofile

exec /usr/bin/xmonad

