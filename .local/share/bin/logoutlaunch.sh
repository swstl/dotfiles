#!/bin/bash

choice=$(echo -e "Log Out\nReboot\nShutdown" | rofi -dmenu -p "Select Action:")

case "$choice" in
    "Log Out")
        hyprctl dispatch exit
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
    *)
        ;;
esac
