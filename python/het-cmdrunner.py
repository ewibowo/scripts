#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

from __future__ import absolute_import, division, print_function

import itertools
import netmiko
try:
    import simplejson as json # Prefer simplejson because of SPEED!
except ImportError:
    import json
import mytools
import os
import sys
import signal
#from trigger.netdevices import NetDevices
#from trigger.conf import settings
#from trigger.netdevices.loader import BaseLoader
#from trigger.exceptions import LoaderFailed


signal.signal(signal.SIGPIPE, signal.SIG_DFL)  # IOError: Broken pipe
signal.signal(signal.SIGINT, signal.SIG_DFL)  # KeyboardInterrupt: Ctrl-C


#if len(sys.argv) < 3:
#    print('Usage: cmdrunner.py commands.txt devices.json')
#    exit()

netmiko_exceptions = (netmiko.ssh_exception.NetMikoTimeoutException,
                      netmiko.ssh_exception.NetMikoAuthenticationException)

#data_source = 'het-devices.json'

with open('het-devices.json', 'r') as contents:
    devices = json.load(contents)
    for d in devices:
        if not d['operatingSystem']:
            sys.exit()
        else:
            print(d['nodeName']['ip'])

#def load_data_source(self, data_source, **kwargs):
#    try:
#        return self.get_data(data_source)
#    except Exception as err:
#        raise LoaderFailed("Tried %r; and failed: %r" % (data_source, err))


#with open('het-devices.json') as device_file:
#    all_devices = json.load(device_file)
#    devices = json.dumps(all_devices, indent=4, sort_keys=True)


print('~'*79)
sys.exit()


ios_devices = [d for d in devices if d['os'] == 'IOS']
print(len(ios_devices))
device_list = []
for device in ios_devices:
    device_list.append(device['host', 'name'])
    print(device_list.sort())

print('~'*79)
sys.exit()

routers = [d for d in devices if d['deviceType'] == 'ROUTER']
print(len(routers))
for router in routers:
    router_list = []
    router_list.append(router['nodeName'])
    print(sorted(router_list))

print('~'*79)

switches = [d for d in devices if d['deviceType'] == 'SWITCH']
print(len(switches))
for switch in switches:
    switch_list = []
    switch_list.append(switch)
    print(sorted(switch_list))

print('~'*79)

sys.exit()

with open('router_cmds.txt') as rtr_file:
    router_commands = rtr_file.readlines()

print(router_commands)
print('~'*79)

with open('switch_cmds.txt') as swi_file:
    switch_commands = swi_file.readlines()

print(switch_commands)
print('~'*79)

username, password = mytools.get_creds()

for device in devices:
    try:
        print('~'*79)
        print('Connecting to ', device['nodeName'])
        connection = netmiko.ConnectHandler(ip=device['ip'], device_type=device['platform'],
                                            username=username, password=password)
        print(connection.send_command('show clock'))
        connection.disconnect()
    except netmiko_exceptions as e:
        print('Failed on ', device['nodeName'], e)
