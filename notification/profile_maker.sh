#!/bin/bash
# Visually pick the projection quad for an image and write/update its entry
# in text_profiles.json.
#
# Usage: ./profile_maker.sh <profile_name> <image_filename>
#   e.g. ./profile_maker.sh bok2 bok2_notif_final.png
#
# A window opens showing the image. Click 4 points, in order:
#   top-left -> top-right -> bottom-right -> bottom-left
# of the area you want text projected onto. Right-click undoes the last
# point. Press Enter to save once all 4 are placed, Escape to cancel.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ $# -ne 2 ]; then
    echo "usage: $0 <profile_name> <image_filename>" >&2
    exit 1
fi

python3 "$SCRIPT_DIR/profile_maker.py" "$1" "$2"
