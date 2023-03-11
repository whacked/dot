#!/usr/bin/env bash

if [ $DESKTOP_SESSION = "sway" ]; then
    MONITOR_NUMBER=1
else
    EDP1_MONITOR_NUMBER=$(xrandr --listactivemonitors | grep eDP-1 | cut -d: -f1)
    MOUSE_X=$(xdotool getmouselocation --shell | grep X= | cut -d= -f2)
    if [ $MOUSE_X -gt 1920 ]; then
        MONITOR_NUMBER=$((1 - $EDP1_MONITOR_NUMBER))
    else
        MONITOR_NUMBER=$EDP1_MONITOR_NUMBER
    fi
fi

if pgrep conky; then
    pkill conky
else
    # override for PATH if env doesn't supply nix-enabled
    # PATH=$HOME/.nix-profile/bin:$PATH
    conky -m $MONITOR_NUMBER -c $HOME/dot/conkyrc &
fi
