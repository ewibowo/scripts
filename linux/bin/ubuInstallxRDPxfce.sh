#!/bin/sh

# Get sudo password at begining
sudo -v
# Update apt
sudo apt-get update
# Install xRDP
sudo apt-get install xrdp
# Install xfce
sudo apt-get install xfce4
# Install XFCE4 terminal (way better than xterm)
sudo apt-get install xfce4-terminal
# Install icon sets
sudo apt-get install gnome-icon-theme-full tango-icon-theme

# Add command to start xfce at session
echo xfce4-session > ~/.xsession
echo startxfce4 >> /etc/xrdp/startwm.sh
# Restart xRDP
sudo service xrdp restart

# File startwm.sh should look like this:
#if [ -r /etc/default/locale ]; then
#  . /etc/default/locale
#  export LANG LANGUAGE
#fi
#
#startxfce4
