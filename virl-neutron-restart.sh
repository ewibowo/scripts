#!/bin/sh

sudo -v
sudo service nova-api restart
sudo service neutron-server restart
sudo service neutron-plugin-linuxbridge-agent restart
sudo service neutron-dhcp-agent restart
sudo service neutron-metadata-agent restart
sudo service neutron-l3-agent restart

