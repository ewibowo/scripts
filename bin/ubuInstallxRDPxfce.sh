#!/bin/sh

sudo apt-get update
sudo apt-get install xrdp
sudo apt-get install xfce4
# Install XFCE4 terminal (way better than xterm)
sudo apt-get install xfce4-terminal

# Install icon sets
sudo apt-get install gnome-icon-theme-full tango-icon-theme

echo xfce4-session > ~/.xsession
echo startxfce4 >> /etc/xrdp/startwm.sh

# File startwm.sh should look like this:
#if [ -r /etc/default/locale ]; then
#  . /etc/default/locale
#  export LANG LANGUAGE
#fi
#
#startxfce4
