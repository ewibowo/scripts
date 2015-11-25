#!/bin/sh

binaries=(
#python —universal —framework Installed manually
#python3 —universal —framework Installed manually
#sshfs
trash
hub
git
ack
autoconf
boost
boost-python
#brew-cask
#dnsmasq
docker
docker-compose
docker-machine
fontconfig
freetype
git
heroku-toolbelt
highlight
libdnet
libevent
libpng
libyaml
markdown
nginx
openssl
packer
pkg-config
pyenv
pyqt
qt
tmux
tree
wakeonlan
wget
xz
z
zeromq
zsh
zsh-completions
macvim
)

echo "installing binaries..."
brew install ${binaries[@]}

brew cleanup
