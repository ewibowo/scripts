Device ID: hsc28-2960XR-sw1.hearstsc.com
Entry address(es):
  IP address: 172.19.10.250
Platform: cisco WS-C2960XR-48FPD-I,  Capabilities: Router Switch IGMP
Interface: GigabitEthernet2/7,  Port ID (outgoing port): GigabitEthernet2/0/48
Holdtime : 129 sec

Version :
Cisco IOS Software, C2960X Software (C2960X-UNIVERSALK9-M), Version 15.2(2)E4, RELEASE SOFTWARE (fc2)

"""
Plugin for gathering info from devices. Only Cisco currently (including ASA).

Will try to parse as much info from commands and place as key-values under
host results. Currently only being done via ``show version`` output. Will
also run all commands listed under ``to_cisco()`` depending on the platform
and can be accessed via each host's ``commands_ran`` dictionary under results.

Use-case is likely limited for well-established networks, but for
environments (MSP) where one might be handed list of IP addresses with
nothing more than device type and credentials this can provide extremely
helpful to just build a quick NetDevices CSV and gather a bunch of info
quickly. For example::
"""

import os
from trigger import tacacsrc
from trigger.conf import settings
from trigger.netdevices import NetDevices
from trigger.contrib.commando.plugins import gather_info


settings.NETDEVICES_SOURCE = os.path.abspath('het-netdevices.json')
settings.DEFAULT_REALM = 'het'
os.environ['TRIGGER_ENABLEPW'] = \
    tacacsrc.get_device_password(settings.DEFAULT_REALM).password

device_list = NetDevices()
gi = GatherInfo(devices=device_list)
gi.run()

print(gi.results)

gi = GatherInfo(devices='hsc-hmg-uu-gw')
gi.run()

print(gi.results)

from trigger.netdevices import NetDevices
from trigger.contrib.commando.plugins import gather_info
nd = NetDevices()
device_list = []
devs = [nd.find('hsc-hmg-uu-gw'), nd.find('hsc-hmg-vz-gw1')]
print devs
gi = gather_info.GatherInfo(devs)
gi.run()
print(gi.results)


#    >>> import os
#    >>> from trigger import tacacsrc
#    >>> from trigger.conf import settings
#    >>> from trigger.netdevices import NetDevices
#    >>> from trigger.contrib.commando.plugins import gather_info
#    >>>
#    >>>
#    >>> settings.NETDEVICES_SOURCE = os.path.abspath('netdevices.csv')
#    >>> settings.DEFAULT_REALM = 'MyRealm'
#    >>> os.environ['TRIGGER_ENABLEPW'] = \
#    >>>     tacacsrc.get_device_password(settings.DEFAULT_REALM).password
#    >>>
#    >>> device_list = NetDevices()
#    >>> gi = GatherInfo(devices=device_list)
#    >>> gi.run()
#    >>>
#    >>> for host, value in gi.results:
#    >>>     print("[{}] {}: {}".format(host,
#                                       value['hostname'],
#                                       value['serial_no']))
#import re
#from trigger.cmds import Commando
#from twisted.python import log
#
#
#task_name = 'gather_info'
#
#
#def xmlrpc_gather_info(*args, **kwargs):
#    """Gather info on specified devices"""
#    log.msg('Creating GatherInfo')
#    gi = GatherInfo(*args, **kwargs)
#    d = gi.run()
#    return d
#
#
#class GatherInfo(Commando):
#    """Extension of Commando class for generating the proper commands to
#    run per-platform.
#    """
#    vendors = ['cisco']
#    ios_shver_parse = re.compile(r'''
#        (?P<hostname>\S*)               (?# Capture Hostname)
#        \suptime\sis\s                  (?# Match " uptime is ")
#        (?P<uptime>[^\r\n]*)            (?# Capture until end of line)
#        .*?^System\simage\sfile\sis\s   (?# Skip until system image line)
#        "[^:]*(?::/|:)                  (?# Match from quote to ':' or ':/')
#        (?P<sw_image>[^"]*)             (?# Capture from slash to end quote)
#        .*?^(?i)cisco\s                 (?# Skip until case insensitive cisco)
#        (?P<model>\S*)                  (?# Capture model number)
#        .*?^Processor\sboard\sID\s      (?# Skip until 'Processor board')
#        (?P<serial_no>\S*)\s            (?# Capture serial number)
#        ''', re.M | re.S | re.X)
#    asa_shver_parse = re.compile(r'''
#        System\simage\sfile\sis\s       (?# Start from System image line)
#        "[^:/]*(?::/|:)                 (?# Match from " and * until :/)
#        (?P<sw_image>[^"]*)             (?# Capture everything until end ")
#        .*?^(?P<hostname>\S*)           (?# .* Until capture hostname)
#        \sup\s                          (?# Match up)
#        (?P<uptime>[^\r\n]*)            (?# Capture uptime)
#        .*?^Hardware:\s+?               (?# Match until Hardware:   )
#        (?P<model>\S*),                 (?# Capture hardwmare model)
#        .*?^Serial\sNumber:\s           (?# Match up to Serial Number)
#        (?P<serial_no>\S*)\s            (?# Capture the serial number)
#        ''', re.M | re.S | re.X)
#
#    def to_cisco(self, device, commands=None, extra=None):
#        """We want different information depending on whether the device
#        is a switch, router, or firewall
#        """
#        if device.is_cisco_asa():
#            return ['show version',
#                    'more system:r',
#                    'show inventory',
#                    'show hostname',
#                    'show hostname fqdn']  # In case reason to need fqdn
#        if device.is_router():
#            return ['show version',
#                    'show run',
#                    'show inventory',
#                    'show cdp neighbor detail',
#                    'show run | i ip domain-name']
#        if device.is_switch():
#            return ['show version',
#                    'show run',
#                    'show inventory',
#                    'show cdp neighbor detail',
#                    'show vtp status',
#                    'show vlan',
#                    'show switch detail',
#                    'show run | i ip domain-name']
#
#    def from_cisco(self, results, device, commands=None):
#        """Parses output of certain commands and add to ``self.results``
#
#        A lot of good information can be retrieved from show version. Method
#        of parsing differs from IOS to ASA.
#
#        Will add keys to each host's dictionary in results for hostname,
#        serial number, software image, and more.
#        """
#        commands_ran = self.generate(device)
#        results_dict = {
#            'commands_ran': self.map_results(commands_ran, results),
#            }
#        show_version = results_dict['commands_ran']['show version']
#        if device.is_cisco_asa():
#            info_dict = self.asa_shver_parse.search(show_version).groupdict()
#        if device.is_router() or device.is_switch():
#            info_dict = self.ios_shver_parse.search(show_version).groupdict()
#
#        results_dict.update(info_dict)
#        self.results[device.nodeName] = results_dict
