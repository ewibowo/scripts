#!/bin/bash

# Must be Linux Kernel 3.16+
sudo apt-get install lxc python3 python3-lxc python3-netaddr

sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install lxc systemd-services uidmap

sudo usermod --add-subuids 100000-165536 $USER
sudo usermod --add-subgids 100000-165536 $USER
sudo chmod +x $HOME

touch ~/.config/lxc/default.conf
echo 'lxc.network.type = veth' >> ~/.config/lxc/default.conf
echo 'lxc.network.link = lxcbr0' >> ~/.config/lxc/default.conf
echo 'lxc.network.flags = up' >> ~/.config/lxc/default.conf
echo 'lxc.network.hwaddr = 00:16:3e:xx:xx:xx' >> ~/.config/lxc/default.conf
echo 'lxc.id_map = u 0 100000 65536' >> ~/.config/lxc/default.conf
echo 'lxc.id_map = g 0 100000 65536' >> ~/.config/lxc/default.conf

touch /etc/lxc/lxc-usernet
echo 'rlaney veth lxcbr0 10' >> /etc/lxc/lxc-usernet

# See it in the files:
grep rlaney /etc/sub* 2>/dev/null
# /etc/subgid:rlaney:100000:65536
# /etc/subuid:rlaney:100000:65536

grep rlaney /etc/lxc/lxc-usernet 2>/dev/null
# rlaney veth lxcbr0 10
