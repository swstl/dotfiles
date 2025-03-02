#!/bin/bash

# Get the ID of the currently focused window
window_id=$(hyprctl activewindow | grep "ID:" | awk '{print $2}')

# Toggle the "pinned" state of the window
hyprctl dispatch togglepin "$window_id"
