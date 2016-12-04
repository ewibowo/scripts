#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

from __future__ import absolute_import, division, print_function

import netmiko
import json
import mytools
import sys
import signal
#from trigger.netdevices import NetDevices

signal.signal(signal.SIGPIPE, signal.SIG_DFL)  # IOError: Broken pipe
signal.signal(signal.SIGINT, signal.SIG_DFL)  # KeyboardInterrupt: Ctrl-C

device_type = 'cisco_ios'
username = 'rlaney'
password = 'ralrox22'

netmiko_exceptions = (netmiko.ssh_exception.NetMikoTimeoutException,
                      netmiko.ssh_exception.NetMikoAuthenticationException)

with open('netdevices.json') as device_file:
    devices = json.load(device_file)

for device in devices:
    ip = device['ipv4']
    device_type = 'cisco_ios'
    username = 'rlaney'
    password = 'ralrox22'
    try:
        print('~'*79)
        print('Connecting to ', device)
        connection = netmiko.ConnectHandler(**device)
        print(connection.send_command('show clock'))
        connection.disconnect()
    except netmiko_exceptions as e:
        print('Failed to ', device, e)
