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

ios_devices = [d for d in mydevices if d['os'] == 'IOS']
print('Total IOS devices unsanitized: {}'.format(len(ios_devices)))
ios_list = set()
for dev in ios_devices:
    device_type = dev['deviceType']
    node = (dev['nodeName']), (dev['ip']), (device_type)
    ios_list.add(node)

print('Total IOS devices duplicates removed: {}'.format(len(ios_list)))
print('~'*79)
routers = [d for d in ios_list if d[2].__contains__('Router')]
print('Total IOS routers: {}'.format(len(routers)))
print('~'*79)
switches = [d for d in ios_list if d[2].__contains__('Switch')]
print('Total IOS switches: {}'.format(len(switches)))
print('~'*79)


with open('router_cmds.txt') as rtr_file:
    router_commands = rtr_file.readlines()


with open('switch_cmds.txt') as swi_file:
    switch_commands = swi_file.readlines()

username = 'etnoc'
password = 'circlebackaround'
#username, password = mytools.get_creds()

devices = ios_devices
for device in devices:
    try:
        if device['deviceType'].__contains__('Router'):
            print('Connecting to router {} with IP {}'.format(device['nodeName'],
                                                              device['ip']))
            connection = netmiko.ConnectHandler(ip=device['ip'],
                                                device_type='cisco_ios',
                                                username=username,
                                                password=password)
            router_file = 'router-' + connection.base_prompt + '.txt'
            with open(router_file, 'w') as out_file:
                for command in router_commands:
                    out_file.write('### Output of ' + command + '\n\n')
                    out_file.write(connection.send_command(command) + '\n\n')
                    print('~'*79)
            connection.disconnect()
        elif device['deviceType'].__contains__('Switch'):
            print('Connecting to switch {} with IP {}'.format(device['nodeName'],
                                                              device['ip']))
            connection = netmiko.ConnectHandler(ip=device['ip'],
                                                device_type='cisco_ios',
                                                username=username,
                                                password=password)
            switch_file = 'switch-' + connection.base_prompt + '.txt'
            with open(switch_file, 'w') as out_file:
                for command in switch_commands:
                    out_file.write('### Output of ' + command + '\n\n')
                    out_file.write(connection.send_command(command) + '\n\n')
                    print('~'*79)
            connection.disconnect()
        else:
            print('This device was not identified as a switch or router.\n')
            print('Name: {} IP: {} DeviceType: {}'.format(device['nodeName'],
                                                          device['ip'],
                                                          device['deviceType']))
    except netmiko_exceptions as e:
        print('Failed on {} with error: {}'.format(device['nodeName'], e))
