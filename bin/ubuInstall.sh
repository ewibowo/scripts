#!/bin/sh

package_list = "vim wget git curl zsh git-core vnstat vde2 sqlite3 mongodb tkmib tcpick tcpreplay tcpspy tcpstat tcptrack ansible  tcpxtract tgn speedometer snort smokeping ipcalc scli redis-server qemu qemu-utils  python3.4 python3.4-venv python3-pysnmp4 python3-networkx python3-ipaddr python3-ipy python3-lxc python3-netaddr python-scapy python-twisted python-pysnmp4 python-redis python-pynetsnmp python-netsnmp python-networkx python-nemu python-netaddr python-ipaddr python-ipy python-ipcalc"

sudo -v
sudo apt-get -y install $package_list

EXIT 0
