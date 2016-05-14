#!/bin/sh

# Get sudo password at begining
sudo -v
# Install xRDP
sudo apt-get install xrdp software-properties-common
# Add the lxqt repository
sudo add-apt-repository ppa:lubuntu-dev/lubuntu-daily
# Update pulling down repo stuff
sudo apt-get update
# Upgrade
sudo apt-get upgrade
# Install lxqt packages
sudo apt-get install lxqt-metapackage openbox lxqt-panel lxqt-session lxsession
# Add command to start lxqt at session
echo startlxqt >~/.xsession
# Restart xRDP
sudo service xrdp restart
