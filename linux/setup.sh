#!/bin/sh

# Setup user
#echo "rlaney ALL=NOPASSWD: ALL" > /etc/sudoers.d/boostrap
#chmod 0400 /etc/sudoers.d/boostrap
#sudo groupadd admin
#sudo usermod -g admin rlaney
#sudo service sudo restart
#
## Install packages
general_package = "git git-core zsh tmux wget curl vim python-distribute python-setuptools python-pip python3-pip fontconfig ruby expect virtualenv virtualenvwrapper vim-nox-py2 vim-python-jedi vim-syntastic vim-khuno python3.5-dbg python3.5-dev python3.5-doc python3.5-examples python-dbg python-dev python-doc python-examples"

#develop_package = "vnstat vde2 sqlite3 mongodb tkmib tcpick tcpreplay tcpspy tcpstat tcptrack ansible  tcpxtract tgn speedometer snort smokeping ipcalc scli redis-server qemu qemu-utils python3.4 python3.4-venv python3-pysnmp4 python3-networkx python3-ipaddr python3-ipy python3-lxc python3-netaddr python-scapy python-twisted python-pysnmp4 python-redis python-pynetsnmp python-netsnmp python-networkx python-nemu python-netaddr python-ipaddr python-ipy python-ipcalc"
#
sudo -v
sudo apt-get update
sudo apt-get -y install $general_package
#sudo apt-get -y install $develop_package
#
#sudo pip install virtualenv
#sudo pip install virtualenvwrapper
#
#gem install bundler
#gem install tmuxinator

git clone https://github.com/rlaneyjr/dotfiles.git ~/.dotfiles
#git clone https://github.com/rlaneyjr/scripts.git ~/scripts
git clone https://github.com/rlaneyjr/vim.git ~/.vim
git clone https://github.com/rlaneyjr/zsh.git ~/.zsh
git clone https://github.com/rlaneyjr/zplug.git ~/.zplug
git clone https://github.com/rlaneyjr/config.git ~/.config

mkdir -p ~/Projects
mkdir -p ~/.virtualenvs

./bin/linkBatch.sh
./bin/linkdots.sh
