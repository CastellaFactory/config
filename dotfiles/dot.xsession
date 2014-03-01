#!/bin/sh

eval $(cat ~/.fehbg) &
kmix --keepvisibility &
compton -b -C -G --config ~/.compton.conf &
/usr/lib64/kde4/libexec/polkit-kde-authentication-agent-1 &

ibus-daemon -dx &
SpiderOak &
dropbox &
stalonetray &
(sleep 3; xmodmap ~/.Xmodmap) &
dropbox &
xset -b

xrdb -merge ~/.vim/bundle/base16-xresources/base16-ocean.dark.xresources
xrdb -merge ~/.Xresources

exec /usr/bin/xmonad
