#!/bin/bash

# Check if rofi is installed
if command -v rofi &>/dev/null; then
  # Launch Rofi in drun mode with custom theme
  rofi -show drun -show-icons -theme ~/.config/rofi/default.rasi
else
  # Send notification if rofi is missing
  notify-send "Launcher Error" "Rofi is not installed."
  exit 1
fi
