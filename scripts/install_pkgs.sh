#!/bin/bash
set -e  # Exit on error

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
    pacman -Qi "$1" &> /dev/null
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
if ! command -v paru &> /dev/null; then
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
dependencies=("git" "base-devel" "hyprland" "pipewire" "python3" "python-pipx" "kitty" "stow" "unzip" "xdg-desktop-portal-hyprland" "polkit-kde-agent" "qt5-wayland" "qt6-wayland")
for dep in "${dependencies[@]}"; do
    install_package "$dep"
done

# Install assets
print_section "Installing assets"
print_subsection "Installing fonts"
fonts=("ttf-cascadia-code-nerd" "ttf-cascadia-mono-nerd" "ttf-fira-code" "ttf-fira-mono" "ttf-fira-sans" "ttf-firacode-nerd" "ttf-iosevka-nerd" "ttf-iosevkaterm-nerd" "ttf-jetbrains-mono-nerd" "ttf-jetbrains-mono" "ttf-nerd-fonts-symbols" "ttf-nerd-fonts-symbols" "ttf-nerd-fonts-symbols-mono")
for font in "${fonts[@]}"; do
    install_package "$font"
done

print_subsection "Installing icon theme"
install_package "papirus-icon-theme"

print_subsection "Downloading wallpapers"
mkdir -p $HOME/wallpapers
if ! command -v gdown &> /dev/null; then
    print_info "Install gdown for downloading from google drive"
    pipx install gdown
else   
    print_info "gdown is already installed"
fi
gdown --fuzzy https://drive.google.com/file/d/1J-voIphjsK-dmrqVHWtIORIAL6TtNyGD/view?usp=drive_link -O $HOME/wallpapers/wallpapers.zip 
unzip -o -q $HOME/wallpapers/wallpapers.zip -d $HOME/wallpapers
rm -f $HOME/wallpapers/wallpapers.zip

# Install packages
print_section "Installing packages"
pkgs=("waybar" "rofi-wayland" "swww" "cliphist" "hyprpicker" "hyprlock" "hypridle" "nwg-look" "qt5ct" "qt6ct" "kvantum")
for pkg in "${pkgs[@]}"; do
    install_package "$pkg"
done

# Install other packages from AUR 
aur_pkgs=("wlogout" "grimblast" "cava")
for pkg in "${aur_pkgs[@]}"; do
    install_aur_package "$pkg"
done