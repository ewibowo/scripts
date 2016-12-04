#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

from __future__ import absolute_import, division, print_function

from ipaddress import IPv4Address
import netmiko
import paramiko
import json
import mytools
import os
import sys
import signal
#from trigger.netdevices import NetDevices

signal.signal(signal.SIGPIPE, signal.SIG_DFL)  # IOError: Broken pipe
signal.signal(signal.SIGINT, signal.SIG_DFL)  # KeyboardInterrupt: Ctrl-C


#if len(sys.argv) < 3:
#    print('Usage: cmdrunner.py commands.txt devices.json')
#    exit()

#netmiko_exceptions = (netmiko.ssh_exception.NetMikoTimeoutException,
#                      netmiko.ssh_exception.NetMikoAuthenticationException,
#                      paramiko.ssh_exception.SSHException, ValueError,
#                      KeyError, IOError)

with open('netdevices.json') as device_file:
    all_devices = json.load(device_file)
    mydevices = mytools.byteify(all_devices)

for d in mydevices:
    try:
        if not d['os']:
            continue
        elif d['os'] != 'IOS':
            continue
        else:
            print('{}\t\t\t{}'.format(d['host'], d['name']))
    except:
        continue
