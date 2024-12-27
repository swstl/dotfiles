#!/bin/bash

case "$1" in
    -o) # Output volume control
        case "$2" in
            m) pactl set-sink-mute @DEFAULT_SINK@ toggle ;; # Mute/unmute
            i) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;   # Increase volume
            d) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;   # Decrease volume
        esac
        ;;
    -i) # Input volume control (microphone)
        case "$2" in
            m) pactl set-source-mute @DEFAULT_SOURCE@ toggle ;; # Mute/unmute mic
        esac
        ;;
esac
