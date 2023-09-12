#!/bin/bash
#
# Script to install my core programs in Linux OS
# This script works in multiple distros
# Created by: @arktnld
#

# Function Section

# Define package lists for different distros
declare -A packageLists
packageLists["debian"]="neovim fzf nnn silversearcher-ag python-is-python3 python3-pip mlocate man-db man-pages tree bc patool zsh git gh exa"
packageLists["arch"]="neovim fzf nnn the_silver_searcher trash-cli mlocate man-db man-pages tree bc patool zsh git github-cli exa paru"

# Define distro-specific commands
declare -A updateCommands
updateCommands["debian"]="apt update -y"
updateCommands["arch"]="pacman -Syu --noconfirm"

# Define user-specific operations
userOperations=("chsh -s /bin/zsh" "timedatectl set-timezone America/Sao_Paulo")

# Function to update packages
update_packages() {
    local distro="$1"
    eval "${updateCommands[$distro]}"
}

# Function to install packages
install_packages() {
    local package_manager="$1"
    local distro="$2"
    eval "$package_manager install -y ${packageLists[$distro]}"
}

# Function to perform user-specific operations
perform_user_operations() {
    local current_user
    current_user=$(whoami)
    for operation in "${userOperations[@]}"; do
        sudo -u "$current_user" $operation
    done
}

# Function to move directories
move_directories() {
    local source_dir="$1"
    local destination_dir="$2"
    sudo -u "$current_user" mv "$source_dir" "$destination_dir"
}

# Function to check for root privileges
check_root_privileges() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root. Please use sudo or run as root."
        exit 1
    fi
}

# Function to detect the distribution
detect_distribution() {
    if [[ -f /etc/debian_version ]]; then
        distro="debian"
    elif [[ -f /etc/arch-release ]]; then
        distro="arch"
    else
        echo "Unsupported distribution."
        exit 1
    fi
}

# Function to get the package manager based on the distribution
get_package_manager() {
    local distro="$1"
    if [[ $distro == "debian" ]]; then
        echo "apt"
    elif [[ $distro == "arch" ]]; then
        echo "pacman"
    else
        echo "Unsupported distribution."
        exit 1
    fi
}

# Execution Section

# Check for root privileges
check_root_privileges

# Detect the distribution
detect_distribution


# Get the package manager based on the distribution
package_manager=$(get_package_manager "$distro")

# Update and install packages
update_packages "$distro"
install_packages "$package_manager" "$distro"

# Perform user-specific operations
perform_user_operations

# Clone dotfiles repository as the regular user
sudo -u "$current_user" git clone --recurse-submodules https://github.com/arktnld/dotfiles

# Move user-specific configurations
move_directories "dotfiles/.config/zsh" "~/.config/"
move_directories "dotfiles/.config/nvim" "~/.config/"
move_directories "dotfiles/.config/less" "~/.config/"
move_directories "dotfiles/.zshenv" "~/"

# Create a directory as the regular user
sudo -u "$current_user" mkdir -p "~/.local/share/zsh"

# Cleanup
rm -rf dotfiles

# Optional: Configure Pacman color
# if [[ $distro == "arch" ]]; then
#    echo 'Color' >> /etc/pacman.conf
# fi

echo "Installation complete."
