#!/usr/bin/env bash

EDP1_MONITOR_NUMBER=$(xrandr --listactivemonitors | grep eDP-1 | cut -d: -f1)
MOUSE_X=$(xdotool getmouselocation --shell | grep X= | cut -d= -f2)
if [ $MOUSE_X -gt 1920 ]; then
    MONITOR_NUMBER=$((1 - $EDP1_MONITOR_NUMBER))
else
    MONITOR_NUMBER=$EDP1_MONITOR_NUMBER
fi

if pgrep conky; then
    pkill conky
else
    conky -m $MONITOR_NUMBER -c $HOME/dot/conkyrc &
fi
