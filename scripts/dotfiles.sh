#!/bin/bash
set -e  # Exit on error

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

# Ask user
read -p "Do you want to setup my dotfiles? (y/n): " setup_answer
setup_answer=${setup_answer,,}  # Convert to lowercase

if [[ "$setup_answer" == "y" || "$setup_answer" == "yes" ]]; then
    
    ### Clone dotfiles ###
    if [ -d "$CLONE_DIR" ]; then
        print_info "Directory $CLONE_DIR already exists."
        read -p "Do you want to remove it? (y/n): " remove_answer
        
        if [[ "$remove_answer" == "y" || "$remove_answer" == "yes" ]]; then
            print_info "Removing $CLONE_DIR..."
            rm -rf "$CLONE_DIR"
            
            # Clone the repository
            print_info "Cloning dotfiles from ${PURPLE}$REPO_URL${NC} into ${PURPLE}$CLONE_DIR${NC}..."
            git clone "$REPO_URL" "$CLONE_DIR"
        else
            print_info "Skipping removal of ${PURPLE}$CLONE_DIR${NC}."
        fi
        
    fi
    

    ### Install dotfiles ###
    print_section "Installing dotfiles"
    
    if [ -d "$SCRIPTS_DIR" ]; then
        while true; do
            print_info "Avaliable scripts:"
            
            # List available scripts
            scripts=("$SCRIPTS_DIR"/*.sh)
            for i in "${!scripts[@]}"; do
                script_name=$(basename "${scripts[$i]}")
                echo "[$((i+1)))]: $script_name"
            done
            
            # Prompt user to choose script
            read -p "Enter the number of the script to run: " choice
            
            # Validate choice
            if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#script_files[@]} )); then
                selected_script="${script_files[$((choice-1))]}"
                print_info "Running ${GREEN}$selected_script${NC}..."
                bash "$selected_script"
                print_info "Script completed successfully."
            else
                print_error "Invalid choice. Please enter a valid number."
                exit 1
            fi
        done
    else
        print_error "No scripts directory found at $SCRIPTS_DIR."
        exit 1
    fi
    
else
    print_info "You chose not to clone dotfiles."
fi