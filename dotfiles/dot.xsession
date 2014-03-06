#!/bin/sh

eval $(cat ~/.fehbg) &
kmix --keepvisibility &
compton -b -C -G --config ~/.compton.conf &
/usr/lib64/kde4/libexec/polkit-kde-authentication-agent-1 &

ibus-daemon -dx &
SpiderOak &
dropbox &
stalonetray &
(sleep 3; dropbox) &
xset -b

xrdb -merge ~/.Xresources

if [[ -e "$HOME/.xsession_local" ]]; then
        source $HOME/.xsession_local
fi

exec /usr/bin/xmonad
