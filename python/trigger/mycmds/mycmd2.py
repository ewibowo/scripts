#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

from __future__ import absolute_import, division, print_function

import json
from trigger.cmds import Commando
#from trigger.netdevices import NetDevices
import signal

signal.signal(signal.SIGPIPE, signal.SIG_DFL)  # IOError: Broken pipe
signal.signal(signal.SIGINT, signal.SIG_DFL)  # KeyboardInterrupt: Ctrl-C

"""
Execute the following on a list of Cisco devices:
"""
#nd = NetDevices()
#[d for d in nd.all() if d.operatingSystem == 'IOS']
#device_list = d.match(site='Hearst Service Center')
device_list = ['hsc28-bc1-sw1', 'hsc28-bc1-sw2']
command_list = ['show clock']

cmd = Commando(devices=device_list, commands=command_list)

cmd.run() # Commando exposes this to start the event loop

print('\nUnparsed Results:\n')
json.dumps(cmd.results, indent=4)

print('\nParsed Results:\n')
json.dumps(cmd.parsed_results, indent=4)

#def main():
#    """A simple syntax check and dump of all we see and know!"""
#    print 'Syntax ok.'
#    if len(sys.argv) > 1:
#        from trigger.netdevices import NetDevices
#        nd = NetDevices()
#        names = sorted(nd)
#        for name in names:
#            dev = nd[name]
#            if dev.deviceType not in ('ROUTER', 'SWITCH'):
#                continue
#            acls = sorted(dev.acls)
#            print '%-39s %s' % (name, ' '.join(acls))
#
#if __name__ == '__main__':
#    main()

