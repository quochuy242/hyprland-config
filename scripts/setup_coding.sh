#!/bin/bash
set -e # Exit on error

# Set up colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Dotfiles repo URL
REPO_URL="https://github.com/quochuy242/dotfiles.git"
CLONE_DIR="$HOME/dotfiles"
SCRIPTS_DIR="$CLONE_DIR/scripts"

# Function for printing section headers
print_section() {
  echo -e "\n${BLUE}===${NC} ${YELLOW}$1 ${BLUE}=== ${NC}\n"
}
print_subsection() {
  echo -e "\n ${GREEN}$1 ${NC}\n"
}
print_info() {
  echo -e "$1 \n"
}
print_error() {
  echo -e "${RED}$1${NC} \n"
}

# Setup rust by rustup
print_section "Setup rust"
if command -v rustup &>/dev/null; then
  rustup default stable
  print_info "Setup rust completely"
else
  print_error "Rustup does not exist"
fi
