#!/bin/bash

SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

brightnessctl -m | cut -d, -f4 | tr -d '%'

socat - UNIX-CONNECT:$SOCK | while read -r line; do
    case "$line" in
        "custom>>brightness"*)
            brightnessctl -m \
            | cut -d, -f4 \
            | tr -d '%'
            ;;
    esac
done
