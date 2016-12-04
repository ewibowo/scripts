#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

from __future__ import absolute_import, division, print_function

import json
from trigger.cmds import Commando
from trigger.netdevices import NetDevices

nd = NetDevices()
device_list = nd.match(deviceTags='neteng1')


class ShowMeTheMoney(Commando):
    """Execute the following on a list of Cisco devices:
        'terminal length 0'
        'show ip int brief'
        'show interface status'
        'show cdp neighbors'
        'show ip arp'
        'show mac address-table'
    vendors = ['cisco']
    """
    commands = [
        'terminal length 0',
        'show ip int brief',
        'show interface status',
        'show ip arp',
        'show mac address-table',
        'show cdp neighbors',
        'show cdp neighbors detail'
    ]

if __name__ == '__main__':
    showstuff = ShowMeTheMoney(devices=device_list)
    showstuff.run() # Commando exposes this to start the event loop

    print '\nUnparsed Results:\n'
    json.dumps(showstuff.results, indent=4)

    print '\nParsed Results:\n'
    json.dumps(showstuff.parsed_results, indent=4)
