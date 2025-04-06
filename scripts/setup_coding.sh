#!/bin/bash
set -e # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths
REPO_URL="https://github.com/quochuy242/dotfiles.git"
CLONE_DIR="$HOME/dotfiles"
SCRIPTS_DIR="$CLONE_DIR/scripts"

# Print functions
print_section() { echo -e "\n${BLUE}=== ${YELLOW}$1 ${BLUE}===${NC}\n"; }
print_subsection() { echo -e " ${GREEN}$1${NC}\n"; }
print_info() { echo -e "$1\n"; }
print_error() { echo -e "${RED}$1${NC}\n"; }

# Setup rust
setup_rust() {
  print_section "Setup Rust"
  sudo pacman -S --needed --noconfirm rustup
  if command -v rustup &>/dev/null; then
    rustup default stable
    print_info "Rust installed successfully."
  else
    print_error "Rustup not found."
  fi
}

# Setup Docker
setup_docker() {
  print_section "Setup Docker & Podman"
  sudo pacman -S --needed --noconfirm docker docker-compose podman
  paru -S --noconfirm lazydocker-bin
  print_info "Enabling docker service"
  sudo systemctl enable --now docker.service

  # Check if Docker started successfully
  if sudo systemctl is-active --quiet docker.service; then
    print_info "Docker service is running."
  else
    print_error "Docker service failed to start."
  fi

  sudo usermod -aG docker "$USER"
  print_info "Added $USER to docker group. Please log out and log back in to apply changes."
}

# Setup R
setup_r() {
  print_section "Setup R & languageserver"
  sudo pacman -S --needed --noconfirm r
  if [ ! -d "$HOME/.local/share/R/library" ]; then
    mkdir -p "$HOME/.local/share/R/library/"
  fi
  R -e 'install.packages("languageserver", repos="https://cloud.r-project.org", lib="~/.local/share/R/library")'
}

# Setup C/C++ & Lua
setup_cpp_lua() {
  print_section "Setup C/C++ & Lua"
  sudo pacman -S --needed --noconfirm clang base-devel gcc lua luarocks
}

# Setup Python
setup_python() {
  print_section "Setup Python"
  sudo pacman -S --needed --noconfirm python python-pip python-pipx python-virtualenv uv
}

# Setup Golang
setup_go() {
  print_section "Setup Golang and tools"
  sudo pacman -S --needed --noconfirm go
  go install \
    golang.org/x/tools/gopls@latest \
    golang.org/x/tools/cmd/goimports@latest \
    golang.org/x/lint/golint@latest \
    github.com/go-delve/delve/cmd/dlv@latest \
    honnef.co/go/tools/cmd/staticcheck@latest &
}

# Setup NodeJS
setup_node() {
  print_section "Setup Node.js and npm"
  sudo pacman -S --needed --noconfirm nodejs npm
}

# Main
main() {
  setup_rust
  setup_docker
  setup_r
  setup_cpp_lua
  setup_python
  setup_go
  setup_node
  print_info "${GREEN}✅ All setups completed!${NC}"
}

main "$@"
