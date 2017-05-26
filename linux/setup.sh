#!/bin/sh

set e
sudo -v

# Setup user
#sudo echo "rlaney ALL=NOPASSWD: ALL" > /etc/sudoers.d/boostrap
#sudo chmod 0400 /etc/sudoers.d/boostrap
#sudo groupadd admin
#sudo usermod -g admin rlaney
#sudo service sudo restart
#
## Install packages
general_package="git git-core zsh tmux wget curl vim build-essential libssl-dev libffi-dev python-distribute python-setuptools python-pip python3-pip python-openssl fontconfig ruby expect virtualenv virtualenvwrapper vim-nox-py2 vim-python-jedi vim-syntastic vim-khuno python3.5-dbg python3.5-dev python3.5-doc python3.5-examples python-dbg python-dev python-doc python-examples"

#develop_package = "vnstat vde2 sqlite3 mongodb tkmib tcpick tcpreplay tcpspy tcpstat tcptrack ansible  tcpxtract tgn speedometer snort smokeping ipcalc scli redis-server qemu qemu-utils python3.4 python3.4-venv python3-pysnmp4 python3-networkx python3-ipaddr python3-ipy python3-lxc python3-netaddr python-scapy python-twisted python-pysnmp4 python-redis python-pynetsnmp python-netsnmp python-networkx python-nemu python-netaddr python-ipaddr python-ipy python-ipcalc"

sudo apt-get update
for package in $general_package; do
    sudo apt-get -y install $package
done
sudo apt-get -y install $develop_package

sudo pip install virtualenv
sudo pip install virtualenvwrapper

gem install bundler
gem install tmuxinator

git clone https://github.com/rlaneyjr/dotfiles.git ~/.dotfiles
#git clone https://github.com/rlaneyjr/scripts.git ~/scripts
git clone https://github.com/rlaneyjr/vim.git ~/.vim
git clone https://github.com/rlaneyjr/zsh.git ~/.zsh
git clone https://github.com/rlaneyjr/lib.git ~/lib
git clone https://github.com/rlaneyjr/zplug.git ~/.zplug
git clone https://github.com/rlaneyjr/config.git ~/.config
git clone https://github.com/rlaneyjr/tmux.git ~/.tmux
git clone https://github.com/rlaneyjr/tmuxinator.git ~/.tmuxinator

mkdir -p ~/Projects
mkdir -p ~/.virtualenvs

source $HOME/scripts/bin/linkBatch.sh
source $HOME/scripts/bin/linkdots.sh
