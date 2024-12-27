#!/bin/bash
# this script fetches the battery percentage using the UPower tool
# this script is currently not used an may be deleted if wanted.
# can add this later if needed

path=$(upower -e | grep "battery")
percentage=$(upower -i $path | grep -E "percentage" | awk '{print $2}' | tr -d "%")

echo $percentage
