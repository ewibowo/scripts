#!/bin/sh

openstack-config --get --format=sh /etc/neutron/neutron.conf linux_bridge
physical_interface_mappings=flat:em1,flat1:em3,ext-net:p2p2

