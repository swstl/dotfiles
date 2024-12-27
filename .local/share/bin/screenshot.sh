#!/bin/bash

screenshot_dir="$HOME/Pictures/Screenshots"
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

case "$1" in
    s) grim -g "$(slurp)" "$screenshot_dir/screenshot_$timestamp.png" ;; # Select area
    sf) grim -g "$(slurp)" -f "$screenshot_dir/screenshot_$timestamp.png" ;; # Frozen select area
    m) grim -o "$screenshot_dir/monitor_$timestamp.png" ;; # Active monitor
    p) grim "$screenshot_dir/allmonitors_$timestamp.png" ;; # All monitors
esac
