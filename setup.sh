chmod +x ./scripts/*.sh

# Install packages
bash ./scripts/install_pkgs.sh

# Setup coding
bash ./scripts/setup_coding.sh

# Install dotfiles
bash ./scripts/dotfiles.sh

# Apply the config
cd $HOME/hyprland-ricing/
stow .
