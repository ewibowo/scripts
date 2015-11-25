#!/bin/sh

binaries=(
#graphicsmagick
#webkit2png
rename
#zopfli
#ffmpeg
cscope
gdbm
pcre
sqlite
node
nvm
lua
ruby-build
rbenv
rbenv-default-gems
rbenv-gem-rehash
#rcm
readline
reattach-to-user-namespace
sbt
#scala Installed manually
scapy
sip
)

echo "installing binaries..."
brew install ${binaries[@]}

brew cleanup
