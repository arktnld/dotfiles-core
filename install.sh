#!/bin/bash
#
# Script to install my core programs in Linux OS
# This script works in multiple distros
# Created by: @arktnld
#

# Get username
read -p "Enter your username: " username

# Function Section

# Define package lists for different distros
declare -A packageLists
# packageLists["debian"]="neovim fzf nnn silversearcher-ag python-is-python3 python3-pip mlocate man-db man-pages tree bc patool zsh git gh exa"
packageLists["arch"]="neovim fzf nnn the_silver_searcher trash-cli mlocate man-db man-pages tree bc patool zsh git github-cli exa paru"

# Define distro-specific commands
declare -A updateCommands
updateCommands["debian"]="apt update -y"
updateCommands["arch"]="pacman -Syu --noconfirm"

# Define distro-specific commands
declare -A installCommands
installCommands["debian"]="apt install -y"
installCommands["arch"]="pacman -S --noconfirm"

directories_to_move=(
    "dotfiles/.config/zsh .config/ $username"
    "dotfiles/.config/nvim .config/ $username"
    "dotfiles/.config/less .config/ $username"
    "dotfiles/.zshenv . $username"
)

# Define user-specific operations
userOperations=("chsh -s /bin/zsh")

# Function to update packages
update_packages() {
    echo "Updating packages"
    local distro="$1"
    eval "${updateCommands[$distro]}"
}

# Function to install packages
install_packages() {
    echo "install packages"
    local distro="$1"
    eval "${installCommands[$distro]}" "${packageLists[$distro]}"
}

# Function to perform user-specific operations
perform_user_operations() {
    echo "Perform user operations"
    username=$1
    for operation in "${userOperations[@]}"; do
        sudo -u "$username" $operation

    done
}

# Function to move directories
move_directories() {
    local source_dir="$1"
    local destination_dir="$2"
    local username="$3"
    echo mv "$source_dir" "$destination_dir"
    sudo -u "$username" mv "$source_dir" "$destination_dir"
}

# Function to check for root privileges
check_root_privileges() {
    echo "Cheking root privilegies"
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root. Please use sudo or run as root."
        exit 1
    fi
}

# Function to detect the distribution
detect_distribution() {
    # echo "Detecting distro name"
    if [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/arch-release ]]; then
        echo "arch"
    else
        echo "Unsupported distribution."
        exit 1
    fi
}
update_timedate() {
    is_wsl() {
        grep -qi "Microsoft" /proc/version
    }
    if ! is_wsl; then
      timedatectl set-timezone America/Sao_Paulo
    fi
}

# Function to get the package manager based on the distribution
# Execution Section

# Check for root privileges
 check_root_privileges

# Detect the distribution
distro=$(detect_distribution)
echo "distro: $distro"

# Update and install packages
update_packages "$distro"
install_packages "$distro"

# Perform user-specific operations
perform_user_operations "$username"

# update timedate to Brazil
update_timedate

# Clone dotfiles repository as the regular user
sudo -u "$username" git clone --recurse-submodules https://github.com/arktnld/dotfiles


# Move user-specific configurations using a for loop
for dir_info in "${directories_to_move[@]}"; do
    eval move_directories $dir_info
done

# Create a directory as the regular user
sudo -u "$username" mkdir -p ".local/share/zsh"

# Cleanup
rm -rf dotfiles

# Optional: Configure Pacman color
# if [[ $distro == "arch" ]]; then
#    echo 'Color' >> /etc/pacman.conf
# fi

echo "Installation complete."
