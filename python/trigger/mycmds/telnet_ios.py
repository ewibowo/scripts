#!/usr/bin/env python

from netmiko import ConnectHandler
from getpass import getpass

device = {
    'device_type': 'cisco_ios_telnet',
    'ip': '10.10.10.70',
    'username': 'pyclass',
    'password': getpass(),
}
net_connect = ConnectHandler(**device)
output = net_connect.send_command('show arp')
print()
print('-' * 50)
print(output)
print(net_connect.find_prompt())
print('-' * 50)
print()
