#!/bin/sh

nitrogen --restore
kmix --keepvisibility &
compton -b -C -G --config ~/.compton.conf &
(sleep 3; /usr/lib64/kde4/libexec/polkit-kde-authentication-agent-1) &

fcitx &
SpiderOakONE &
stalonetray &
(sleep 4; dropbox) &
xset -b

xrdb -merge ~/.Xresources

if [[ -e "$HOME/.xsession_local" ]]; then
    source $HOME/.xsession_local
fi

exec /usr/bin/xmonad

