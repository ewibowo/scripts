#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

from __future__ import absolute_import, division, print_function

import netmiko
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

netmiko_exceptions = (netmiko.ssh_exception.NetMikoTimeoutException,
                      netmiko.ssh_exception.NetMikoAuthenticationException)

with open('new-netdevices.json') as device_file:
    all_devices = json.load(device_file)
    mydevices = mytools.byteify(all_devices)

''' Get all the IOS devices seperated and duplicates removed '''
ios_devices = [d for d in mydevices if d['os'] == 'IOS']
print('Total IOS devices unsanitized: {}'.format(len(ios_devices)))
ios_list = set()
for dev in ios_devices:
    device_type = dev['deviceType']
    node = (dev['nodeName']), (dev['ip']), (device_type)
    ios_list.add(node)


''' Get all the NXOS devices seperated and duplicates removed '''
nxos_devices = [d for d in mydevices if d['os'] == 'NXOS']
print('Total NXOS devices unsanitized: {}'.format(len(nxos_devices)))
nxos_list = set()
for dev in nxos_devices:
    device_type = dev['deviceType']
    node = (dev['nodeName']), (dev['ip']), (device_type)
    nxos_list.add(node)


print('Total IOS devices duplicates removed: {}'.format(len(ios_list)))
print('Total NXOS devices duplicates removed: {}'.format(len(nxos_list)))
print('~'*79)


with open('ios_cmds.txt') as ios_file:
    ios_commands = ios_file.readlines()


with open('nxos_cmds.txt') as nxos_file:
    nxos_commands = nxos_file.readlines()


username = 'rlaney'
password = 'ralrox22'
#username, password = mytools.get_creds()


with open('log_file.txt', 'w') as log_file:
    try:
        for device in ios_devices:
            print('Connecting to IOS {} with IP {}'.format(device['nodeName'],
                                                           device['ip']))
            connection = netmiko.ConnectHandler(ip=device['ip'],
                                                device_type='cisco_ios',
                                                username=username,
                                                password=password)
            with open('IOS-Results.txt', 'w') as ios_file:
                for command in ios_commands:
                    ios_file.write('IOS Device: ' + connection.base_prompt + '\n')
                    ios_file.write('### Output of ' + command + '\n')
                    ios_file.write(connection.send_command(command) + '\n')
                    ios_file.write('~'*79)
            connection.disconnect()
        for device in nxos_devices:
            print('Connecting to NXOS {} with IP {}'.format(device['nodeName'],
                                                            device['ip']))
            connection = netmiko.ConnectHandler(ip=device['ip'],
                                                device_type='cisco_nxos',
                                                username=username,
                                                password=password)
            with open('NXOS-Results.txt', 'w') as nxos_file:
                for command in nxos_commands:
                    nxos_file.write('NXOS Device: ' + connection.base_prompt + '\n')
                    nxos_file.write('### Output of ' + command + '\n')
                    nxos_file.write(connection.send_command(command) + '\n')
                    nxos_file.write('~'*79)
            connection.disconnect()
    except netmiko_exceptions as e:
        log_file.write('Failed on {} with IP: {} \n'.format(device['nodeName'],
                                                            device['ip']))
        log_file.write('Error: {} \n'.format(e))
        log_file.write('~'*79)
