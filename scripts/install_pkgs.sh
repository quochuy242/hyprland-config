#!/bin/bash
set -e # Exit on error

# Set up colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
YELLOW='\033[0;33m'

# Function for printing section headers
print_section() {
  echo -e "\n${BLUE}===${NC} ${GREEN}$1 ${BLUE}=== ${NC}\n"
}
print_info() {
  echo -e "${NC} ${YELLOW}$1${NC}\n"
}
print_subsection() {
  echo -e "\n ${GREEN}$1 ${NC}\n"
}

# Function to check if a package is installed
is_installed() {
  pacman -Qi "$1" &>/dev/null
}

# Function to install a package
install_package() {
  if ! is_installed "$1"; then
    print_info "Installing $1"
    sudo pacman -S --needed --noconfirm "$1"
  else
    print_info "$1 is already installed"
  fi
}

# Function to install a package from AUR
install_aur_package() {
  if ! is_installed "$1"; then
    print_info "Installing $1 from AUR"
    paru -S --needed --noconfirm "$1"
  else
    print_info "$1 is already installed"
  fi
}

# Go Home
cd ~

# Create local bin directory if it doesn't exist
mkdir -p ~/.local/bin

print_section "Updating system"
sudo pacman -Syu --noconfirm

# Check if paru is already installed
print_section "Installing paru AUR helper"
if ! command -v paru &>/dev/null; then
  print_section "Installing paru AUR helper"
  git clone https://aur.archlinux.org/paru.git $HOME/paru
  cd $HOME/paru
  makepkg -si --noconfirm
  cd ~
else
  print_info "paru is already installed"
fi

# Install dependencies
print_section "Installing dependencies"
dependencies=("git" "base-devel" "hyprland" "pipewire" "ffmpeg" "playerctl" "kitty" "stow" "unzip" "xdg-desktop-portal-hyprland" "polkit-kde-agent" "qt5-wayland" "qt6-wayland" "brightnessctl" "cliphist" "dunst")
for dep in "${dependencies[@]}"; do
  install_package "$dep"
done

# Install coding stuff
print_section "Installing programming language"
programs=("rustup" "python3" "python-pipx" "r" "gcc" "go" "make" "just" "uv")
for program in "${programs[@]}"; do
  install_package "$program"
done

# Install assets
print_section "Installing assets"
print_subsection "Installing fonts"
fonts=("ttf-cascadia-code-nerd" "ttf-cascadia-mono-nerd" "ttf-fira-code" "ttf-fira-mono" "ttf-fira-sans" "ttf-firacode-nerd" "ttf-iosevka-nerd" "ttf-iosevkaterm-nerd" "ttf-jetbrains-mono-nerd" "ttf-jetbrains-mono" "ttf-nerd-fonts-symbols" "ttf-nerd-fonts-symbols" "ttf-nerd-fonts-symbols-mono" "adwaita-fonts")
for font in "${fonts[@]}"; do
  install_package "$font"
done

print_subsection "Installing icon theme"
install_package "papirus-icon-theme"

print_subsection "Installing catppuccin-gtk-theme-mocha"
install_aur_package "catppuccin-gtk-theme-mocha"

print_subsection "Downloading wallpapers"
wallpaper_dir="$HOME/wallpapers/"

read -p "Do you want to download my list wallpapers (CAUTION: >= 1.1GB) (y/n): " wallpaper_choice
wallpaper_choice=${wallpaper_choice,,} # Convert to lowercase

if [[ "$wallpaper_choice" == "y" || "$wallpaper_choice" == "yes" ]]; then
  if [ -d "$wallpaper_dir" ]; then
    print_info "The $wallpaper_dir exists"
    read -p "Do you want to remove your wallpaper (y/n): " remove_wallpaper_choice
    remove_wallpaper_choice=${remove_wallpaper_choice,,}
    if [[ "$remove_wallpaper_choice" == "y" || "$remove_wallpaper_choice" == "yes" ]]; then
      rm -rf "$wallpaper_dir"
    elif [[ "$remove_wallpaper_choice" == "n" || "$remove_wallpaper_choice" == "no" ]]; then
      wallpaper_dir="$HOME/quochuy242_wallpapers"
    else
      print_info "Invalid choice, do nothing"
    fi
  fi

  mkdir -p "$wallpaper_dir"
  print_info "Clone quochuy242's wallpaper collections"
  git clone https://github.com/quochuy242/wallpapers.git "$wallpaper_dir"
else
  print_info "Skip installing wallpapers"
fi

# Install packages
print_section "Installing packages"
pkgs=("waybar" "rofi-wayland" "swww" "hyprpicker" "hyprlock" "hypridle" "nwg-look" "qt5ct" "qt6ct" "kvantum")
for pkg in "${pkgs[@]}"; do
  install_package "$pkg"
done

# Install other packages from AUR
aur_pkgs=("grimblast" "cava" "bemoji")
for pkg in "${aur_pkgs[@]}"; do
  install_aur_package "$pkg"
done

# Install desktop app
print_section "Installing some desktop applications"
pacman_apps=("obs-studio" "code" "obsidian" "pavucontrol" "mpv" "imv" "telegram-desktop")
aur_apps=("brave-bin" "zen-browser-bin" "zoom")
for app in "${pacman_apps[@]}"; do
  install_package "$app"
done
for app in "${aur_apps[@]}"; do
  install_aur_package "$app"
done

# Setup Vietnamese typing
read -p "Do you want to setup Vietnamese typing by using fcitx5-unikey (y/n): " vietnam_choice
vietnam_choice=${vietnam_choice,,}

if [[ "$vietnam_choice" == "y" || "$vietnam_choice" == "yes" ]]; then
  install_package "fcitx5 fcitx5-unikey fcitx5-qt fcitx5-gtk fcitx5-configtool" # For hyprland
  install_aur_package "ibus-bamboo"                                             # For GNOME
elif [[ "$vietnam_choice" == "n" || "$vietnam_choice" == "no" ]]; then
  print_info "Skip setup Vietnamese typing"
else
  print_info "Invalid choice"
fi
