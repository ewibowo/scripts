#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

from __future__ import absolute_import, division, print_function

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

netmiko_exceptions = (netmiko.ssh_exception.NetMikoTimeoutException,
                      netmiko.ssh_exception.NetMikoAuthenticationException,
                      paramiko.ssh_exception.SSHException, ValueError,
                      KeyError, IOError)

with open('netdevices.json') as device_file:
    all_devices = json.load(device_file)
    mydevices = mytools.byteify(all_devices)

''' Get all the IOS devices seperated and duplicates removed '''
ios_devices = []
try:
    ios_devices = [d for d in mydevices if d['os'] == 'IOS']
except KeyError:
    print('Device {} is missing os key'.format(d['name']))

ios_list = set()
for dev in ios_devices:
    device_type = dev['deviceType']
    node = (dev['name']), (dev['host']), (device_type)
    ios_list.add(node)


''' Get all the NXOS devices seperated and duplicates removed '''
nxos_devices = []
try:
    nxos_devices = [d for d in mydevices if d['os'] == 'NXOS']
except KeyError:
    print('Device {} is missing os key'.format(d['name']))

nxos_list = set()
for dev in nxos_devices:
    device_type = dev['deviceType']
    node = (dev['name']), (dev['host']), (device_type)
    nxos_list.add(node)


with open('ios_cmds.txt') as ios_file:
    ios_commands = ios_file.readlines()


with open('nxos_cmds.txt') as nxos_file:
    nxos_commands = nxos_file.readlines()


username = 'etnoc'
password = 'circlebackaround'
#username, password = mytools.get_creds()


log_file = open('log_file.txt', 'w')
elog_file = open('error_log_IOS.txt', 'w')
nlog_file = open('error_log_NXOS.txt', 'w')

log_file.write('Total IOS devices unsanitized: {} \n'.format(len(ios_devices)))
log_file.write('Total sanitized IOS devices: {} \n'.format(len(ios_list)))
log_file.write('~'*79 + '\n\n')


for device in ios_devices:
    try:
        print('Connecting to IOS {} with IP {} \n'.format(device['name'],
                                                       device['host']))
        log_file.write('Connecting to IOS {} with IP {} \n'.format(
                       device['name'], device['host']))
        connection = netmiko.ConnectHandler(device_type='cisco_ios',
                                            ip=device['host'],
                                            username=username,
                                            password=password,
                                            global_delay_factor=2)
        print('IOS Device: ' + connection.base_prompt + '\n')
        log_file.write('IOS Device: ' + connection.base_prompt + '\n')
        log_file.write(connection.send_config_set(ios_commands))
        log_file.write(connection.send_command('write memory'))
        connection.disconnect()
        log_file.write('~'*79 + '\n\n')
        print('~'*79 + '\n\n')
    except netmiko_exceptions as e:
        elog_file.write('Failed on {} with IP: {} \n'.format(
                        device['name'], device['host']))
        elog_file.write('Error: {} \n'.format(e))
        elog_file.write('~'*79 + '\n\n')

        print('Failed on {} with IP: {} \n'.format(device['name'],
        print('Error: {} \n'.format(e))
        print('~'*79 + '\n')

log_file.write('Total NXOS devices unsanitized: {} \n'.format(len(nxos_devices)))
log_file.write('Total sanitized NXOS devices: {} \n'.format(len(nxos_list)))
log_file.write('~'*79 + '\n\n')
for device in nxos_devices:
    try:
        print('Connecting to NXOS {} with IP {} \n'.format(device['name'],
                                                        device['host']))
        log_file.write('Connecting to NXOS {} with IP {} \n'.format(
                       device['name'], device['host']))
        connection = netmiko.ConnectHandler(device_type='cisco_nxos',
                                            ip=device['host'],
                                            username=username,
                                            password=password,
                                            global_delay_factor=2)
        print('NXOS Device: ' + connection.base_prompt + '\n')
        log_file.write('NXOS Device: ' + connection.base_prompt + '\n')
        log_file.write(connection.send_config_set(nxos_commands))
        log_file.write(connection.send_command('copy run start'))
        connection.disconnect()
        log_file.write('~'*79 + '\n\n')
        print('~'*79 + '\n')
    except netmiko_exceptions as n:
        nlog_file.write('Failed on {} with IP: {} \n'.format(
                        device['name'], device['host']))
        nlog_file.write('Error: {} \n'.format(n))
        nlog_file.write('~'*79 + '\n\n')

        print('Failed on {} with IP: {} \n'.format(device['name'],
                                                   device['host']))
        print('Error: {} \n'.format(e))
        print('~'*79 + '\n')


log_file.close()
elog_file.close()
nlog_file.close()
