#!/bin/bash

# Get the current layout
current_layout=$(setxkbmap -query | grep layout | awk '{print $2}')

# Toggle between "us" and "your-layout"
if [ "$current_layout" == "us" ]; then
    setxkbmap your-layout
else
    setxkbmap us
fi
