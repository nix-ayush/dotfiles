#!/bin/sh
IMAGE="/tmp/swaylock-blur.png"

# Capture screen and quickly pixelate/blur via scale down -> scale up
grim "$IMAGE"
magick "$IMAGE" -scale 10% -scale 1000% "$IMAGE"

# frosted
# magick "$IMAGE" -scale 10% -scale 1000% -fill "#0a1226" -colorize 45% "$IMAGE"

swaylock \
    -i "$IMAGE" \
    --indicator-radius 120 \
    --indicator-thickness 10 \
    --ring-color 0088cc \
    --inside-color 1a1a2e88 \
    --line-color 00000000 \
    --separator-color 00000000 \
    --text-color 00eeff \
    --ring-ver-color 00ffcc \
    --inside-ver-color 1a1a2e88 \
    --text-ver-color 00eeff \
    --ring-wrong-color ff5555 \
    --inside-wrong-color 1a1a2e88 \
    --text-wrong-color ff5555 \
    --bs-hl-color abb2bf

# Clean up temporary screenshot on unlock
rm -f "$IMAGE"
