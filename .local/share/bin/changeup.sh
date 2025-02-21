#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

d_dir=$(echo "$1" | base64 --decode 2>/dev/null)

if [ -z "$d_dir" ] || [ ! -d "$d_dir" ]; then
    echo "Error: Decoded directory is invalid or does not exist."
    notify-send "Error: Invalid directory!"
    exit 1
fi

echo "$d_dir" > "$HOME/.config/wp_dr"

notify-send "Wallpaper folder changed to $(basename "$d_dir")"
