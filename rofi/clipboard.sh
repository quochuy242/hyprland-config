#!/bin/bash

# Check if rofi and cliphist are installed
if command -v rofi &>/dev/null && command -v cliphist &>/dev/null; then
  # Open clipboard manager with Rofi and custom theme
  cliphist list | rofi -dmenu -theme ~/.config/rofi/default.rasi -p "Clipboard:" | cliphist decode | wl-copy
else
  # Send notification if missing dependencies
  notify-send "Clipboard Error" "Rofi and/or cliphist are not installed."
  exit 1
fi
