#!/bin/sh

compton -b -C -G --config ~/.compton.conf &
(sleep 3; /usr/lib64/kde4/libexec/polkit-kde-authentication-agent-1) &

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

exec /usr/bin/xmonad

