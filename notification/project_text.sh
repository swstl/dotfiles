#!/bin/bash
# Perspective-project text onto a specific spot on a character image, using the
# quad coordinates stored in text_profiles.json for that image.
#
# Usage: ./project_text.sh <profile_name> "text to project" [output_path]
#
# To add a new image: add an entry to text_profiles.json with:
#   image        - filename of the base image (in this directory)
#   canvas_width/canvas_height - full pixel size of that image
#   src_width/src_height       - size of the flat rectangle text gets drawn into
#                                 before warping (kept at origin 0,0)
#   dst          - the 4 destination corners the flat rectangle's corners get
#                  warped to, in order: top-left, top-right, bottom-right,
#                  bottom-left (as x1,y1,x2,y2,x3,y3,x4,y4)
#   font, color  - text styling

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROFILES="$SCRIPT_DIR/text_profiles.json"

PROFILE="${1:?usage: project_text.sh <profile_name> \"text\" [output_path]}"
TEXT="${2:?usage: project_text.sh <profile_name> \"text\" [output_path]}"
OUTPUT="${3:-$SCRIPT_DIR/projected_output.png}"

if ! jq -e ".\"$PROFILE\"" "$PROFILES" >/dev/null 2>&1; then
    echo "error: no profile named '$PROFILE' in $PROFILES" >&2
    exit 1
fi

profile_field() { jq -r ".\"$PROFILE\".$1" "$PROFILES"; }

IMAGE="$SCRIPT_DIR/$(profile_field image)"
CANVAS_W="$(profile_field canvas_width)"
CANVAS_H="$(profile_field canvas_height)"
SRC_W="$(profile_field src_width)"
SRC_H="$(profile_field src_height)"
FONT="$(profile_field font)"
COLOR="$(profile_field color)"

# dst is stored as a JSON array [x1,y1,x2,y2,x3,y3,x4,y4]
DST=($(jq -r ".\"$PROFILE\".dst[]" "$PROFILES"))
DST_TL_X=${DST[0]}; DST_TL_Y=${DST[1]}
DST_TR_X=${DST[2]}; DST_TR_Y=${DST[3]}
DST_BR_X=${DST[4]}; DST_BR_Y=${DST[5]}
DST_BL_X=${DST[6]}; DST_BL_Y=${DST[7]}

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# 1. Render the text into a flat rectangle (auto-shrinks to fit via caption:),
#    then extend it onto a canvas the size of the full base image, anchored
#    at the top-left (0,0) - this is our "source" rectangle for the warp.
magick -size "${SRC_W}x${SRC_H}" -background none -fill "$COLOR" -font "$FONT" \
    -gravity center caption:"$TEXT" \
    -background none -gravity NorthWest -extent "${CANVAS_W}x${CANVAS_H}" \
    "$TMP_DIR/flat.png"

# 2. Perspective-warp the source rectangle's 4 corners onto the configured
#    destination quad, keeping the canvas size fixed so it aligns with the
#    base image.
magick "$TMP_DIR/flat.png" -virtual-pixel transparent -distort Perspective \
    "0,0,${DST_TL_X},${DST_TL_Y}  ${SRC_W},0,${DST_TR_X},${DST_TR_Y}  ${SRC_W},${SRC_H},${DST_BR_X},${DST_BR_Y}  0,${SRC_H},${DST_BL_X},${DST_BL_Y}" \
    -set option:distort:viewport "${CANVAS_W}x${CANVAS_H}+0+0" \
    "$TMP_DIR/warped.png"

# 3. Composite the warped text onto a fresh copy of the base image.
magick "$IMAGE" "$TMP_DIR/warped.png" -composite "$OUTPUT"

echo "$OUTPUT"
