#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

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


from trigger.netdevices import NetDevices
from twisted.internet import reactor

nd = NetDevices()
dev = nd.find('foo1-abc')

def print_result(data):
    """Display results from a command"""
    print 'Result:', data

def stop_reactor(data):
    """Stop the event loop"""
    print 'Stopping reactor'
    if reactor.running:
        reactor.stop()

# Create an event chain that will execute a given list of commands on this
# device
async = dev.execute(['show clock'])

# When we get results from the commands executed, call this
async.addCallback(print_result)

# Once we're out of commands, or we an encounter an error, call this
async.addBoth(stop_reactor)

# Start the event loop
reactor.run()

'''
Execute commands asynchronously using the Commando API
------------------------------------------------------

`~trigger.cmds.Commando` tries to hide Twisted's implementation details so you
don't have to deal with callbacks, while also implementing a worker pool so
that you may easily communicate with multiple devices in parallel.

This is a base class that is intended to be extended to perform the operations
you desire. Here is a basic example of how we might perform the same example
above using `~trigger.cmds.Commando` instead, but also communicating with a
second device in parallel:
'''

from trigger.cmds import Commando

class ShowClock(Commando):
    """Execute 'show clock' on a list of Cisco devices."""
    vendors = ['cisco']
    commands = ['show clock']

if __name__ == '__main__':
    device_list = ['foo1-abc.net.aol.com', 'foo2-xyz.net.aol.com']
    showclock = ShowClock(devices=device_list)
    showclock.run() # Commando exposes this to start the event loop

    print '\nResults:'
    print showclock.results

'''
Get structured data back using the Commando API
-----------------------------------------------

`~trigger.cmds.Commando` will attempt to parse the raw command output into a
nested dict. The results from each worker are parsed through the `TextFSM
<http://jedelman.com/home/programmatic-access-to-cli-devices-with-textfsm/>`_
templating engine, if a matching template file exists within the
:setting:`TEXTFSM_TEMPLATE_DIR` directory.

For this to work you must have an attribute on your netdevices model that
specifies the network operating system, e.g. IOS, NX-OS or JUNOS. This will be
used to correlate the right template for a given device based on the naming
convention used by the TextFSM templates.
'''


import json
from trigger.cmds import Commando

device_list = ['172.16.1.101,']


class ShowMeTheMoney(Commando):
    """Execute the following on a list of Cisco devices:
        'show clock'
        'show version'
        'show ip int brief'
        'show inventory'
        'show run | in cisco'
    """
    vendors = ['cisco']
    commands = [
        'show clock',
        'show version',
        'show ip int brief',
        'show inventory',
        'show run | in cisco'
    ]

if __name__ == '__main__':
    showstuff = ShowMeTheMoney(devices=device_list)
    showstuff.run() # Commando exposes this to start the event loop

    print '\nUnparsed Results:\n'
    json.dumps(showstuff.results, indent=4)

    print '\nParsed Results:\n'
    json.dumps(showstuff.parsed_results, indent=4)

