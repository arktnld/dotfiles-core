#!/bin/bash
#
# Script to install my core programs in Linux OS
# This script works in multiple distros
# Created by: @arktnld
#

var_debian="neovim
fzf
nnn
silversearcher-ag
python-is-python3
python3-pip
mlocate
man-db
man-pages
tree
bc
patool
zsh
git
gh
exa
"

var_arch="neovim
fzf
nnn
the_silver_searcher
trash-cli
mlocate
man-db
man-pages
tree
bc
patool
zsh
git
github-cli
exa
paru
"

var_yum=""

# Check if running with root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo or run as root."
    exit 1
fi

# Update packages
if [[ -f /etc/debian_version ]]; then
    apt update -y
    apt upgrade -y
    apt install -y $(echo "$var_debian" | tr '\n' ' ')
    pip install trash-cli pyright
elif [[ -f /etc/centos-release ]]; then
    echo test
elif [[ -f /etc/arch-release ]]; then
    pacman -Syu --noconfirm
    pacman -S --noconfirm $(echo "$var_arch" | tr '\n' ' ')
    echo "nameserver 1.1.1.1" >> /etc/resolv.conf # Fix "gh auth login" error
fi

# Update keyring
pacman-key --init
pacman-key --populate archlinux

# Install the primary key
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB

# Install the Chaotic keyring and mirrorlist
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# Append to /etc/pacman.conf
echo '[chaotic-aur]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf

# Update Pacman
pacman -Sy

# Perform user-specific operations
if [[ -f /etc/arch-release ]]; then
    sudo -u YOUR_USERNAME chsh -s /bin/zsh
    sudo -u YOUR_USERNAME timedatectl set-timezone America/Sao_Paulo

    # Clone dotfiles repository as the regular user
    sudo -u YOUR_USERNAME git clone --recurse-submodules https://github.com/arktnld/dotfiles

    # Move user-specific configurations
    sudo -u YOUR_USERNAME mv dotfiles/.config/zsh ~/.config/
    sudo -u YOUR_USERNAME mv dotfiles/.config/nvim ~/.config/
    sudo -u YOUR_USERNAME mv dotfiles/.config/less ~/.config/
    sudo -u YOUR_USERNAME mv dotfiles/.zshenv ~/

    # Create a directory as the regular user
    sudo -u YOUR_USERNAME mkdir -p ~/.local/share/zsh
fi

# Cleanup
rm -rf dotfiles
