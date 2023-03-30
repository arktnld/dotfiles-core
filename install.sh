#!/bin/bash
declare -A osInfo;
osInfo[/etc/debian_version]="apt-get install -y"
osInfo[/etc/alpine-release]="apk install"
osInfo[/etc/centos-release]="yum install"
osInfo[/etc/fedora-release]="dnf install"
osInfo[/etc/arch-release]="pacman -S"

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

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        package_manager=${osInfo[$f]}
        echo "$package_manager"
    fi
done

# eval "$package_manager" $packages

if [[ -f /etc/debian-release ]];then
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y
    pip install trash-cli pyright
elif [[ -f /etc/centos-release ]]; then

elif [[ -f /etc/arch-release ]]; then
    echo hello2
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
