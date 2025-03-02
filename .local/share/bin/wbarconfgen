#!/bin/bash

config_dir="$HOME/.config/waybar"
current_config="$config_dir/current"
configs=("$config_dir"/*.json)

case "$1" in
    n) # Next configuration
        ln -sf "${configs[$(( ( $(readlink -f "$current_config" | grep -n "$(basename $current_config)" | cut -d: -f1) % ${#configs[@]} ) + 1 ))]}" "$current_config"
        ;;
    p) # Previous configuration
        ln -sf "${configs[$(( ( $(readlink -f "$current_config" | grep -n "$(basename $current_config)" | cut -d: -f1) - 1 + ${#configs[@]} ) % ${#configs[@]} ))]}" "$current_config"
        ;;
esac

# Restart Waybar
killall waybar && waybar &
