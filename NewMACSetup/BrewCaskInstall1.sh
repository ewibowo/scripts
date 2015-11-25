#!/bin/sh

# For beta versions like google-chrome-canary
#brew tap caskroom/versions

# Apps
apps=(
  alfred
  dropbox
#  google-chrome
#  google-chrome-canary
  qlcolorcode
  screenflick
#  slack
#  transmit
  firefox
#  hazel
  qlmarkdown
  seil
#  spotify
  vagrant
  arq
  flash
  iterm2
  qlprettypatch
#  shiori
  sublime-text3
  atom
  flux
#  mailbox
  qlstephen
  sketch
  tower
  cloudup
  nvalt
  quicklook-json
#  skype
appcleaner
#caffeine
#cheatsheet
dockertoolbox
evernote
flux
insomniax
spectacle
#superduper
totalfinder
#transmission
vagrant
vagrant-manager
#valentina-studio
virtualbox
#vlc
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

brew cask cleanup
