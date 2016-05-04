#!/bin/sh

sudo apt-get install xrdp
sudo add-apt-repository ppa:lubuntu-dev/lubuntu-daily
sudo apt-get update

sudo apt-get upgrade

sudo apt-get install lxqt-metapackage lxqt-session lxsession

echo startlxqt >~/.xsession
sudo service xrdp restart
