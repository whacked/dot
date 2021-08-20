#!/usr/bin/env bash
MONITOR_NUMBER=0
if pgrep conky; then
    pkill conky
else
    conky -m $MONITOR_NUMBER -c $HOME/dot/conkyrc &
fi
