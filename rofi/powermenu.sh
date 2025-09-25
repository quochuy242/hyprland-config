#!/bin/bash

# CMDs
uptime="$(uptime -p | sed -e 's/up //g')"

# New Icons (Nerd Fonts or Material Symbols)
shutdown='󰐥'   # Power
reboot='󰑐'     # Refresh
lock='󰌾'       # Lock
suspend='󰽥'    # Moon
logout='󰍃'     # Logout
yes=''        # Check-circle
no=''         # Close-circle

# Rofi CMD
rofi_cmd() {
  rofi -dmenu \
  -p "Goodbye, ${USER}" \
  -mesg "Uptime: $uptime" \
  -theme "$HOME/.config/rofi/powermenu.rasi"
}

# Confirmation CMD
confirm_cmd() {
  rofi -dmenu \
  -p "Confirmation" \
  -mesg "Are you sure?" \
  -theme "$HOME/.config/rofi/confirm.rasi"
}

# Ask for confirmation
confirm_exit() {
  echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
  selected="$(confirm_exit)"
  if [[ "$selected" == "$yes" ]]; then
    case "$1" in
      --shutdown) systemctl poweroff ;;
      --reboot) systemctl reboot ;;
      --suspend)
        mpc -q pause 2>/dev/null
        amixer set Master mute 2>/dev/null
        systemctl suspend
      ;;
      --logout) hyprctl dispatch exit ;;
    esac
  else
    exit 0
  fi
}

# Actions
chosen="$(run_rofi)"
case "$chosen" in
  "$shutdown") run_cmd --shutdown ;;
  "$reboot") run_cmd --reboot ;;
  "$lock") hyprlock ;;
  "$suspend") run_cmd --suspend ;;
  "$logout") run_cmd --logout ;;
esac
