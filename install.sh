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

if [[ -f /etc/debian_version ]];then
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y $(echo "$var_debian" | tr '\n' ' ')
    pip install trash-cli pyright
elif [[ -f /etc/centos-release ]]; then
    echo test

elif [[ -f /etc/arch-release ]]; then
   paru -S --noconfirm $(echo "$var_arch" | tr '\n' ' ')
   sudo echo "nameserver 1.1.1.1" >> /etc/resolv.conf # fix "gh auth login" error
fi

curl https://cht.sh/:cht.sh > ~/.local/bin/cht
chmod +x ~/.local/bin/cht

sudo chsh -s /bin/zsh
sudo timedatectl set-timezone America/Sao_Paulo

git clone --recurse-submodules https://github.com/arktnld/dotfiles

mv dotfiles/.config/zsh ~/.config/
mv dotfiles/.config/nvim ~/.config/
mv dotfiles/.config/less ~/.config/
mv dotfiles/.zshenv ~/

mkdir ~/.local/share/zsh
