#!/bin/bash

# Get the window class of the focused window
window_class=$(hyprctl clients | grep -A4 "$(hyprctl activewindow)" | grep class | awk '{print $2}')

# Check if the window class is "steam"
if [ "$window_class" == "steam" ]; then
    # Minimize the Steam window instead of closing it
    hyprctl dispatch movetoworkspace special
else
    # If it's not Steam, kill the window normally
    hyprctl dispatch closewindow
fi
