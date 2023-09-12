#!/bin/bash
#
# Script to install my core programs in linux OS
# This script works in multipel distros
# create by: @arktnld
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
"
var_yum=""
# eval "$package_manager" $packages

# Check if running with root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo or run as root."
    exit 1
fi

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

if [[ -f /etc/debian_version ]];then
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y $(echo "$var_debian" | tr '\n' ' ')
    pip install trash-cli pyright
elif [[ -f /etc/centos-release ]]; then
    echo test

elif [[ -f /etc/arch-release ]]; then
   pacman -S --noconfirm $(echo "$var_arch" | tr '\n' ' ')
   echo "nameserver 1.1.1.1" >> /etc/resolv.conf # fix "gh auth login" error
fi

curl https://cht.sh/:cht.sh > ~/.local/bin/cht
chmod +x ~/.local/bin/cht

chsh -s /bin/zsh
timedatectl set-timezone America/Sao_Paulo

git clone --recurse-submodules https://github.com/arktnld/dotfiles

mv dotfiles/.config/zsh ~/.config/
mv dotfiles/.config/nvim ~/.config/
mv dotfiles/.config/less ~/.config/
mv dotfiles/.zshenv ~/

mkdir ~/.local/share/zsh
