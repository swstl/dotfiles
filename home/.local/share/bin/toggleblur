#!/bin/bash

# Path to your Hyprland configuration file
CONFIG_FILE="$HOME/.config/hypr/themes/blur.conf"

# Check the current blur status
if grep -q "enabled = yes" "$CONFIG_FILE"; then
    # Disable blur
    sed -i 's/enabled = yes/enabled = no/' "$CONFIG_FILE"
else
    # Enable blur
    sed -i 's/enabled = no/enabled = yes/' "$CONFIG_FILE"
fi

hyprctl reload
