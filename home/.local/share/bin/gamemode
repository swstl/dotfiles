#!/bin/bash

# This would toggle Hyprland effects
current_mode=$(hyprctl getoption general:effects | grep "int:" | awk '{print $2}')

if [ "$current_mode" -eq 1 ]; then
    hyprctl setoption general:effects 0
else
    hyprctl setoption general:effects 1
fi
