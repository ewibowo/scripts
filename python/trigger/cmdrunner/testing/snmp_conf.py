#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

from __future__ import absolute_import, division, print_function

import json
from trigger.cmds import Commando
from trigger.netdevices import NetDevices

nd = NetDevices()
device_list = nd.all()


class ShowMeTheMoney(Commando):
    """
    Execute the following on a list of Cisco devices:
    """

    vendors = ['cisco']
    commands = [
        'terminal length 0',
        'show ip int brief',
        'show interface status',
        'show ip arp',
    ]

if __name__ == '__main__':
    showstuff = ShowMeTheMoney(devices=nd)
    showstuff.run() # Commando exposes this to start the event loop

    print('\nUnparsed Results:\n')
    json.dumps(showstuff.results, indent=4)

    print('\nParsed Results:\n')
    json.dumps(showstuff.parsed_results, indent=4)



#        'terminal length 0',
#        'show ip int brief',
#        'show interface status',
#        'show ip arp',
#        'show mac address-table',
#        'show cdp neighbors',
#        'show cdp neighbors detail'
#        'snmp-server community 0d71d56ae6 RW',
#        'snmp-server host 172.16.1.5 0d71d56ae6',
