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

IMAGE="$SCRIPT_DIR/baked/$(profile_field image)"
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

# src_width/src_height must fit within the canvas, or the -extent step below
# crops instead of scales, silently mangling the text (bunched to one side).
if (( SRC_W > CANVAS_W || SRC_H > CANVAS_H )); then
    echo "error: profile '$PROFILE' has src_width/src_height (${SRC_W}x${SRC_H}) bigger than its canvas (${CANVAS_W}x${CANVAS_H})." >&2
    echo "       Fix the src_width/src_height values in text_profiles.json (usually happens after switching to a different-sized image)." >&2
    exit 1
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

N_SHAPES="$(jq -r ".\"$PROFILE\".occlusion_polygons // [] | length" "$PROFILES")"

# Steps 1-3 (render text, perspective-warp it, composite onto the base image)
# fused into a single ImageMagick call via a sub-image group "( ... )" -
# same operations/order as before, just one process instead of three, and no
# intermediate files hitting disk. If there's no occlusion to apply, write
# straight to the final output; otherwise write to a fast intermediate format
# (.mpc - uncompressed, skips PNG encode/decode) for the occlusion pass below.
if (( N_SHAPES == 0 )); then
    TEXT_TARGET="$OUTPUT"
else
    TEXT_TARGET="$TMP_DIR/composited.mpc"
fi

magick "$IMAGE" \( \
    -size "${SRC_W}x${SRC_H}" -background none -fill "$COLOR" -font "$FONT" \
    -gravity center caption:"$TEXT" \
    -background none -gravity NorthWest -extent "${CANVAS_W}x${CANVAS_H}" \
    -virtual-pixel transparent -distort Perspective \
    "0,0,${DST_TL_X},${DST_TL_Y}  ${SRC_W},0,${DST_TR_X},${DST_TR_Y}  ${SRC_W},${SRC_H},${DST_BR_X},${DST_BR_Y}  0,${SRC_H},${DST_BL_X},${DST_BL_Y}" \
    -set option:distort:viewport "${CANVAS_W}x${CANVAS_H}+0+0" \
\) -composite "$TEXT_TARGET"

# Re-paste anything marked as "occlusion" (e.g. fingers) from the ORIGINAL
# image back on top, so it still appears in front of the text. All shapes are
# combined into one mask (one -draw per polygon) so this is a single extra
# ImageMagick call regardless of how many shapes are marked.
if (( N_SHAPES > 0 )); then
    DRAW_ARGS=()
    for ((i = 0; i < N_SHAPES; i++)); do
        SHAPE=($(jq -r ".\"$PROFILE\".occlusion_polygons[$i][]" "$PROFILES"))
        POLY_POINTS=""
        for ((j = 0; j < ${#SHAPE[@]}; j += 2)); do
            POLY_POINTS="$POLY_POINTS ${SHAPE[j]},${SHAPE[j+1]}"
        done
        DRAW_ARGS+=(-draw "polygon $POLY_POINTS")
    done

    magick "$TEXT_TARGET" \( \
        "$IMAGE" \( -size "${CANVAS_W}x${CANVAS_H}" xc:black -fill white "${DRAW_ARGS[@]}" \) \
        -alpha off -compose CopyOpacity -composite \
    \) -compose Over -composite "$OUTPUT"
fi

echo "$OUTPUT"
