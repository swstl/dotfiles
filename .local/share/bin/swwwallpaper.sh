#!/bin/bash

# Ensure WALLPAPER_DIR is set
WALLPAPER_DIR="${WALLPAPER_DIR:-/home/who/Backgrounds}"

# Validate that WALLPAPER_DIR exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Wallpaper directory '$WALLPAPER_DIR' does not exist."
    exit 1
fi

# File to keep track of the current wallpaper index
INDEX_FILE="${WALLPAPER_DIR}/index"

# Get the list of wallpapers
wallpapers=("$WALLPAPER_DIR"/*.jpg)

# Total number of wallpapers
total_wallpapers=${#wallpapers[@]}

# Check if wallpapers are available
if [ $total_wallpapers -eq 0 ]; then
    echo "Error: No wallpapers found in '$WALLPAPER_DIR'."
    exit 1
fi

# Ensure the index file exists
if [ ! -f "$INDEX_FILE" ]; then
    echo $START_INDEX > "$INDEX_FILE"
fi

# Read the current index from the file
CURRENT_INDEX=$(cat "$INDEX_FILE")

# Parse the script arguments
case "$1" in
    -n|--next)
        # Move to the next wallpaper
        ((CURRENT_INDEX++))
        if [ $CURRENT_INDEX -ge $total_wallpapers ]; then
            CURRENT_INDEX=0
        fi
        echo $CURRENT_INDEX
        ;;
    -p|--previous)
        # Move to the previous wallpaper
        ((CURRENT_INDEX--))
        if [ $CURRENT_INDEX -lt 0 ]; then
            CURRENT_INDEX=$((total_wallpapers - 1))
        fi
        echo $CURRENT_INDEX
        ;;
    *)
        swww-daemon
        swww img --transition-duration 0 -t none "${wallpapers[$START_INDEX]}"
        exit 1
        ;;
esac

# Save the updated index to the file
echo $CURRENT_INDEX > "$INDEX_FILE"

# Set the wallpaper using swww
swww img --transition-duration 0 -t none "${wallpapers[$CURRENT_INDEX]}"
