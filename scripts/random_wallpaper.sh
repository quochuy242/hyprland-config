#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/wallpapers/chillop/"

# Choose a random wallpaper (only image files)
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | shuf -n 1)

# Ensure swww daemon is running
if ! pgrep -x "swww-daemon" >/dev/null; then
  swww-daemon &
  sleep 1 # Give it a moment to start
fi

# Using swww to change the wallpaper
if [ -n "$WALLPAPER" ]; then
  swww img "$WALLPAPER" --transition-fps 255 --transition-type outer --transition-duration 0.8

  # Generate colorscheme with pywal
  # wal -i "$WALLPAPER" --backend auto --saturate 0.5

  # Reload any app that uses the colors if needed
  # Example: reload waybar, rofi, kitty, etc.
  # killall -SIGUSR1 waybar
  # (you can add more here depending on your setup)

else
  echo "No wallpapers found in $WALLPAPER_DIR"
fi
