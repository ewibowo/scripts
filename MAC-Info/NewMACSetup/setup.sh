#!/bin/sh

# Setup user
#echo "rlaney ALL=NOPASSWD: ALL" > /etc/sudoers.d/boostrap
#chmod 0400 /etc/sudoers.d/boostrap
#sudo groupadd admin
#sudo usermod -g admin rlaney
#sudo service sudo restart
#
## Install packages
#general_package = "git git-core zsh tmux wget curl vim python-distribute python-setuptools python-pip python3-pip fontconfig ruby expect"
#
#develop_package = "vnstat vde2 sqlite3 mongodb tkmib tcpick tcpreplay tcpspy tcpstat tcptrack ansible  tcpxtract tgn speedometer snort smokeping ipcalc scli redis-server qemu qemu-utils python3.4 python3.4-venv python3-pysnmp4 python3-networkx python3-ipaddr python3-ipy python3-lxc python3-netaddr python-scapy python-twisted python-pysnmp4 python-redis python-pynetsnmp python-netsnmp python-networkx python-nemu python-netaddr python-ipaddr python-ipy python-ipcalc"
#
#sudo -v
#sudo apt-get update
#sudo apt-get -y install $general_package
#sudo apt-get -y install $develop_package
#
#sudo pip install virtualenv
#sudo pip install virtualenvwrapper
#
#gem install bundler
#gem install tmuxinator
#
#git clone https://github.com/rlaneyjr/dotfiles.git ~/.dotfiles
##git clone https://github.com/rlaneyjr/lscripts.git ~/scripts
#git clone https://github.com/rlaneyjr/lvim.git ~/.vim
#git clone https://github.com/rlaneyjr/lzsh.git ~/.zsh
#git clone https://github.com/rlaneyjr/lzplug.git ~/.zplug
#git clone https://github.com/rlaneyjr/lconfig.git ~/.lconfig
#mkdir -p ~/Projects
#mkdir -p ~/.virtualenvs
#mkdir -p ~/.bin
#ln -s ~/.dotfiles/vimrc ~/.vimrc
#ln -s ~/.dotfiles/vimrc.bundles ~/.vimrc.bundles
#ln -s ~/.dotfiles/zshrc ~/.zshrc
#ln -s ~/.dotfiles/zshenv ~/.zshenv
#ln -s ~/.dotfiles/aliases ~/.aliases
#ln -s ~/.dotfiles/agignore ~/.agignore
#ln -s ~/.dotfiles/gitignore ~/.gitignore
#ln -s ~/.dotfiles/gitignore_global ~/.gitignore_global
#ln -s ~/.dotfiles/gitmessage ~/.gitmessage
#ln -s ~/.dotfiles/gitconfig ~/.gitconfig
#ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

ln -s ~/.dotfiles/admin-openrc.sh      ~/.admin-openrc.sh
ln -s ~/.dotfiles/agignore             ~/.agignore
ln -s ~/.dotfiles/aliases              ~/.aliases
ln -s ~/.dotfiles/demo-openrc.sh       ~/.demo-openrc.sh
ln -s ~/.dotfiles/gemrc                ~/.gemrc
ln -s ~/.dotfiles/gitconfig            ~/.gitconfig
ln -s ~/.dotfiles/gitignore            ~/.gitignore
ln -s ~/.dotfiles/gitignore_global     ~/.gitignore_global
ln -s ~/.dotfiles/gitmessage           ~/.gitmessage
ln -s ~/.dotfiles/hgignore_global      ~/.hgignore_global
ln -s ~/.dotfiles/LESS_TERMCAP         ~/.LESS_TERMCAP
ln -s ~/.dotfiles/macos                ~/.macos
ln -s ~/.dotfiles/mongo_hacker.js      ~/.mongo_hacker.js
ln -s ~/.dotfiles/mongorc.js           ~/.mongorc.js
ln -s ~/.dotfiles/netrc                ~/.netrc
ln -s ~/.dotfiles/powerlevel9k         ~/.powerlevel9k
ln -s ~/.dotfiles/psqlrc               ~/.psqlrc
ln -s ~/.dotfiles/psqlrc.local         ~/.psqlrc.local
ln -s ~/.dotfiles/rspec                ~/.rspec
ln -s ~/.dotfiles/sbtconfig            ~/.sbtconfig
ln -s ~/.dotfiles/tmux.conf            ~/.tmux.conf
ln -s ~/.dotfiles/vimrc                ~/.vimrc
ln -s ~/.dotfiles/vimrc.bundles        ~/.vimrc.bundles
ln -s ~/.dotfiles/zshenv               ~/.zshenv
ln -s ~/.dotfiles/zshrc                ~/.zshrc

sudo cp ~/.dotfiles/hosts /private/etc/hosts






































#source $HOME/scripts/bin/linkBatch.sh
#source $HOME/scripts/rmRepos.exp
#
#EXIT 0
