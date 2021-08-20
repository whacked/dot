#!/usr/bin/env bash

MONITOR_NUMBER=0
MOUSE_X=$(xdotool getmouselocation --shell | grep X= | cut -d= -f2)
if [ $MOUSE_X -gt 1920 ]; then
    MONITOR_NUMBER=1
fi

if pgrep conky; then
    pkill conky
else
    conky -m $MONITOR_NUMBER -c $HOME/dot/conkyrc &
fi
