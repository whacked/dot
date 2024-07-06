#!/usr/bin/env bash

if pgrep conky; then
    pkill conky
    exit
fi

if [ "$DESKTOP_SESSION" = "sway" ]; then
    MONITOR_NUMBER=1
else
    EDP1_MONITOR_NUMBER=$(xrandr --listactivemonitors | grep eDP-1 | cut -d: -f1)
    if [ "$EDP1_MONITOR_NUMBER" == "" ]; then
        MONITOR_NUMBER=1
    else
        MOUSE_X=$(xdotool getmouselocation --shell | grep X= | cut -d= -f2)
        if [ $MOUSE_X -gt 1920 ]; then
            MONITOR_NUMBER=$((1 - $EDP1_MONITOR_NUMBER))
        else
            MONITOR_NUMBER=$EDP1_MONITOR_NUMBER
        fi
    fi
fi

# override for PATH if env doesn't supply nix-enabled
# PATH=$HOME/.nix-profile/bin:$PATH
conky -m $MONITOR_NUMBER -c $HOME/dot/conkyrc &
