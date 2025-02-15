#!/bin/bash

freeze_screen() {
  grim - | swappy -f - &
  sleep 0.1
}

unfreeze_screen() {
  pkill swappy
}

case "$1" in
s) # Select Area Screenshot (Frozen)
  freeze_screen
  grim -g "$(slurp)" - | wl-copy
  unfreeze_screen
  notify-send "Screenshot copied to clipboard!"
  ;;

sf) # Select Area Screenshot (Frozen)
  freeze_screen
  grim -g "$(slurp)" - | wl-copy
  unfreeze_screen
  notify-send "Screenshot copied to clipboard!"
  ;;

m) # Active Monitor Screenshot (Frozen)
  freeze_screen
  grim -o "$(hyprctl activewindow -j | jq -r '.monitor')" - | wl-copy
  unfreeze_screen
  notify-send "Screenshot copied to clipboard!"
  ;;

p) # All Monitors Screenshot (Frozen)
  freeze_screen
  grim - | wl-copy
  unfreeze_screen
  notify-send "Screenshot copied to clipboard!"
  ;;
esac
