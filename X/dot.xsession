#!/bin/sh

if [[ "$DESKTOP_SESSION" =~ Xsession$ ]]; then
    compton -b -C -G --config ~/.compton.conf &
    /usr/lib64/libexec/polkit-kde-authentication-agent-1 &
    stalonetray &
    nitrogen --restore
    fcitx &
    insync start &
    dropbox &
    xset -b

    fish --login --command="exec xmonad"
fi

