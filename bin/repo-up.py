#!/usr/local/bin/python

'''
Program to update/push/pull all repos
To push my config or system related repos:
python repo-up.py -i users.csv -o users.json -f dump

To push my project repos:
python repo-up.py -i users.csv -o users.json -f pretty
'''

import getopt
import signal
import sys
from subprocess import *


signal.signal(signal.SIGPIPE, signal.SIG_DFL)  # IOError: Broken pipe
signal.signal(signal.SIGINT, signal.SIG_DFL)  # KeyboardInterrupt: Ctrl-C

sub_exceptions = (OSError,ValueError)

mess = "The git-update script pushed these"
git_add = ('git add -A')
git_commit = ('git commit -a -m "The git-update script pushed these"')
git_sync = ('git push -u origin master')
git_pull = ('git pull')
git_remote = ('git remote show origin')


my_projects = [
            '/Users/rlaney/.atom',
            '/Users/rlaney/.config',
            '/Users/rlaney/.dotfiles',
            '/Users/rlaney/.tmux',
            '/Users/rlaney/.tmuxinator',
            '/Users/rlaney/.vim',
            '/Users/rlaney/.zplug',
            '/Users/rlaney/.zsh',
            '/Users/rlaney/lib',
            '/Users/rlaney/scripts',
            '/Users/rlaney/vimwiki',
            '/Users/rlaney/repos/hosts',
            '/Users/rlaney/Dropbox (Personal)/cheaters',
            '/Users/rlaney/Dropbox (Personal)/VIRL_Projects',
            '/Users/rlaney/Projects/ansible',
            '/Users/rlaney/Projects/trigger',
            '/Users/rlaney/Projects/NetEngineerONE',
            '/Users/rlaney/Projects/py-snmp',
            '/Users/rlaney/.virtualenvs/neteng/project',
            ]

other_repos = [
            '/Users/rlaney/Projects/VIRL_Projects',
            '/Users/rlaney/Projects/ansible/repo-odl',
            '/Users/rlaney/Projects/ansible/repo-osa',
            '/Users/rlaney/repos/ansible-odl',
            '/Users/rlaney/repos/ansible-osa',
            '/Users/rlaney/repos/APIs/AzureAPIs/azure-sdk-for-python',
            '/Users/rlaney/repos/APIs/AzureAPIs/python-azureml-client',
            '/Users/rlaney/repos/APIs/requests',
            '/Users/rlaney/repos/APIs/wwwclient',
            '/Users/rlaney/repos/APIs/python-slackclient',
            '/Users/rlaney/repos/bird',
            '/Users/rlaney/repos/CiscoDevNet/ACI',
            '/Users/rlaney/repos/CiscoDevNet/aci-ansible',
            '/Users/rlaney/repos/CiscoDevNet/aci-containers',
            '/Users/rlaney/repos/CiscoDevNet/aci-diff',
            '/Users/rlaney/repos/CiscoDevNet/aci-examples',
            '/Users/rlaney/repos/CiscoDevNet/aci-export',
            '/Users/rlaney/repos/CiscoDevNet/aci-fabric-deploy',
            '/Users/rlaney/repos/CiscoDevNet/aci-fault-doc',
            '/Users/rlaney/repos/CiscoDevNet/aci-integration-module',
            '/Users/rlaney/repos/CiscoDevNet/aci-learning-labs',
            '/Users/rlaney/repos/CiscoDevNet/aci-vigilante',
            '/Users/rlaney/repos/CiscoDevNet/acifabriclib',
            '/Users/rlaney/repos/CiscoDevNet/acitoolkit',
            '/Users/rlaney/repos/CiscoDevNet/Ansible-NXOS',
            '/Users/rlaney/repos/CiscoDevNet/api-design-guide',
            '/Users/rlaney/repos/CiscoDevNet/apic-em-samples-aradford',
            '/Users/rlaney/repos/CiscoDevNet/apicapi',
            '/Users/rlaney/repos/CiscoDevNet/apicem-ga-ll-sample-code',
            '/Users/rlaney/repos/CiscoDevNet/arya',
            '/Users/rlaney/repos/CiscoDevNet/cloudcenter-content',
            '/Users/rlaney/repos/CiscoDevNet/cobra',
            '/Users/rlaney/repos/CiscoDevNet/coding-skills-go',
            '/Users/rlaney/repos/CiscoDevNet/coding-skills-sample-code',
            '/Users/rlaney/repos/CiscoDevNet/cosc-learning-labs',
            '/Users/rlaney/repos/CiscoDevNet/cosc-rest-api-python',
            '/Users/rlaney/repos/CiscoDevNet/devnet-dev-vms',
            '/Users/rlaney/repos/CiscoDevNet/FabricResourceCalculation',
            '/Users/rlaney/repos/CiscoDevNet/ignite',
            '/Users/rlaney/repos/CiscoDevNet/itopo',
            '/Users/rlaney/repos/CiscoDevNet/link-state-monitor',
            '/Users/rlaney/repos/CiscoDevNet/netconf-examples',
            '/Users/rlaney/repos/CiscoDevNet/NeXt',
            '/Users/rlaney/repos/CiscoDevNet/nexus5000',
            '/Users/rlaney/repos/CiscoDevNet/nexus7000',
            '/Users/rlaney/repos/CiscoDevNet/nxapi-learning-labs',
            '/Users/rlaney/repos/CiscoDevNet/nxos',
            '/Users/rlaney/repos/CiscoDevNet/nxos-ansible',
            '/Users/rlaney/repos/CiscoDevNet/nxos-examples',
            '/Users/rlaney/repos/CiscoDevNet/nxtoolkit',
            '/Users/rlaney/repos/CiscoDevNet/open-nxos-getting-started',
            '/Users/rlaney/repos/CiscoDevNet/opendaylight-bootcamps',
            '/Users/rlaney/repos/CiscoDevNet/Opendaylight-Openflow-App',
            '/Users/rlaney/repos/CiscoDevNet/opendaylight-sample-apps',
            '/Users/rlaney/repos/CiscoDevNet/opendaylight-setup',
            '/Users/rlaney/repos/CiscoDevNet/opennxos',
            '/Users/rlaney/repos/CiscoDevNet/OPNFV',
            '/Users/rlaney/repos/CiscoDevNet/pceof-gui',
            '/Users/rlaney/repos/CiscoDevNet/perf-automation',
            '/Users/rlaney/repos/CiscoDevNet/pyaci',
            '/Users/rlaney/repos/CiscoDevNet/PyMonitor',
            '/Users/rlaney/repos/CiscoDevNet/restconf-examples',
            '/Users/rlaney/repos/CiscoDevNet/UCS',
            '/Users/rlaney/repos/CiscoDevNet/uniq',
            '/Users/rlaney/repos/CiscoDevNet/vpp-odl',
            '/Users/rlaney/repos/CiscoDevNet/webarya',
            '/Users/rlaney/repos/CiscoDevNet/who-moved-my-cli',
            '/Users/rlaney/repos/CiscoDevNet/yang-examples',
            '/Users/rlaney/repos/CiscoDevNet/yang-explorer',
            '/Users/rlaney/repos/CiscoDevNet/yangman',
            '/Users/rlaney/repos/CiscoDevNet/ydk-gen',
            '/Users/rlaney/repos/CiscoDevNet/ydk-py',
            '/Users/rlaney/repos/CiscoDevNet/ydk-py-samples',
            '/Users/rlaney/repos/aws-transit-vpc',
            '/Users/rlaney/repos/django-wiki',
            '/Users/rlaney/repos/django-wiki-project-template',
            '/Users/rlaney/repos/exscript',
            '/Users/rlaney/repos/GateOne',
            '/Users/rlaney/repos/ghsync',
            '/Users/rlaney/repos/go-netbox',
            '/Users/rlaney/repos/gobgp',
            '/Users/rlaney/repos/HariSekhon/bash-tools',
            '/Users/rlaney/repos/HariSekhon/DataScienceResources',
            '/Users/rlaney/repos/HariSekhon/dockerfile_lint',
            '/Users/rlaney/repos/HariSekhon/Dockerfiles',
            '/Users/rlaney/repos/HariSekhon/hosts',
            '/Users/rlaney/repos/HariSekhon/lib',
            '/Users/rlaney/repos/HariSekhon/lib-java',
            '/Users/rlaney/repos/HariSekhon/links',
            '/Users/rlaney/repos/HariSekhon/my-links',
            '/Users/rlaney/repos/HariSekhon/nagios-plugin-kafka',
            '/Users/rlaney/repos/HariSekhon/nagios-plugins',
            '/Users/rlaney/repos/HariSekhon/nagios-plugins-1',
            '/Users/rlaney/repos/HariSekhon/nrpe-plugins',
            '/Users/rlaney/repos/HariSekhon/pylib',
            '/Users/rlaney/repos/HariSekhon/python-consul',
            '/Users/rlaney/repos/HariSekhon/python-data-workshop',
            '/Users/rlaney/repos/HariSekhon/pytools',
            '/Users/rlaney/repos/HariSekhon/share',
            '/Users/rlaney/repos/HariSekhon/styleguide',
            '/Users/rlaney/repos/HariSekhon/tools',
            '/Users/rlaney/repos/hosts',
            '/Users/rlaney/repos/ivre',
            '/Users/rlaney/repos/KennethReitz/args',
            '/Users/rlaney/repos/KennethReitz/blindspin',
            '/Users/rlaney/repos/KennethReitz/bucketstore',
            '/Users/rlaney/repos/KennethReitz/clint',
            '/Users/rlaney/repos/KennethReitz/crayons',
            '/Users/rlaney/repos/KennethReitz/delegator.py',
            '/Users/rlaney/repos/KennethReitz/dj-database-url',
            '/Users/rlaney/repos/KennethReitz/dj-static',
            '/Users/rlaney/repos/KennethReitz/django-postgrespool',
            '/Users/rlaney/repos/KennethReitz/docker-python',
            '/Users/rlaney/repos/KennethReitz/envoy',
            '/Users/rlaney/repos/KennethReitz/goldenarch',
            '/Users/rlaney/repos/KennethReitz/legit',
            '/Users/rlaney/repos/KennethReitz/markdownplease.com',
            '/Users/rlaney/repos/KennethReitz/maya',
            '/Users/rlaney/repos/KennethReitz/ovaltine',
            '/Users/rlaney/repos/KennethReitz/pip-pop',
            '/Users/rlaney/repos/KennethReitz/pip-purge',
            '/Users/rlaney/repos/KennethReitz/pipenv',
            '/Users/rlaney/repos/KennethReitz/tablib',
            '/Users/rlaney/repos/KennethReitz/xerox',
            '/Users/rlaney/repos/LanXchange',
            '/Users/rlaney/repos/LinuxONLY/blueprint',
            '/Users/rlaney/repos/mininet',
            '/Users/rlaney/repos/mininet-tests',
            '/Users/rlaney/repos/mininet-util',
            '/Users/rlaney/repos/Net_Graph/NetGraph1',
            '/Users/rlaney/repos/Net_Graph/NetGraph2',
            '/Users/rlaney/repos/Net_Graph/NetGraph3',
            '/Users/rlaney/repos/Net_Graph/NetGraph4',
            '/Users/rlaney/repos/netbox',
            '/Users/rlaney/repos/Network_Automation/ansible-trigger',
            '/Users/rlaney/repos/Network_Automation/Automation',
            '/Users/rlaney/repos/Network_Automation/autonet',
            '/Users/rlaney/repos/Network_Automation/bgpranking-redis-api',
            '/Users/rlaney/repos/Network_Automation/bosun',
            '/Users/rlaney/repos/Network_Automation/bsn-ansible',
            '/Users/rlaney/repos/Network_Automation/cisco_netmiko',
            '/Users/rlaney/repos/Network_Automation/cpauto',
            '/Users/rlaney/repos/Network_Automation/cpcloud',
            '/Users/rlaney/repos/Network_Automation/dns-crawl',
            '/Users/rlaney/repos/Network_Automation/ipspace-NetworkAutomation/add_dhcp_helper_address',
            '/Users/rlaney/repos/Network_Automation/ipspace-NetworkAutomation/ansible-examples',
            '/Users/rlaney/repos/Network_Automation/ipspace-NetworkAutomation/MPLS-infrastructure',
            '/Users/rlaney/repos/Network_Automation/ipspace-NetworkAutomation/NetOpsWorkshop',
            '/Users/rlaney/repos/Network_Automation/ipspace-NetworkAutomation/sot_vlans',
            '/Users/rlaney/repos/Network_Automation/ipspace-NetworkAutomation/VIRL',
            '/Users/rlaney/repos/Network_Automation/ipspace-NetworkAutomation/VLAN-service',
            '/Users/rlaney/repos/Network_Automation/napalm',
            '/Users/rlaney/repos/Network_Automation/napalm-ansible',
            '/Users/rlaney/repos/Network_Automation/net-config',
            '/Users/rlaney/repos/Network_Automation/netman',
            '/Users/rlaney/repos/Network_Automation/netmiko',
            '/Users/rlaney/repos/Network_Automation/Netmiko training',
            '/Users/rlaney/repos/Network_Automation/netmiko-ansible',
            '/Users/rlaney/repos/Network_Automation/netmiko-cisco-playground',
            '/Users/rlaney/repos/Network_Automation/netmiko-ppaskowsky',
            '/Users/rlaney/repos/Network_Automation/netmiko_test',
            '/Users/rlaney/repos/Network_Automation/netmiko_tools',
            '/Users/rlaney/repos/Network_Automation/NetSpark-Scripts',
            '/Users/rlaney/repos/Network_Automation/network-automation',
            '/Users/rlaney/repos/Network_Automation/NetworkAutomation',
            '/Users/rlaney/repos/Network_Automation/NetworkAutomationProject',
            '/Users/rlaney/repos/Network_Automation/NetworkAutomationUsingPython',
            '/Users/rlaney/repos/Network_Automation/ntc-ansible',
            '/Users/rlaney/repos/Network_Automation/ntc-ansible-docs',
            '/Users/rlaney/repos/Network_Automation/ntc-templates',
            '/Users/rlaney/repos/Network_Automation/pyntc',
            '/Users/rlaney/repos/Network_Automation/pynxos',
            '/Users/rlaney/repos/Network_Automation/test-network-modules',
            '/Users/rlaney/repos/Network_Automation/vzp_cisco-config-evaluator',
            '/Users/rlaney/repos/newspaper',
            '/Users/rlaney/repos/oc-pyang',
            '/Users/rlaney/repos/odl/ansible-opendaylight',
            '/Users/rlaney/repos/odl/controller',
            '/Users/rlaney/repos/odl/networking-odl',
            '/Users/rlaney/repos/onie',
            '/Users/rlaney/repos/onos',
            '/Users/rlaney/repos/Openstack_DevToolBox/dragonflow',
            '/Users/rlaney/repos/Openstack_DevToolBox/grafyaml',
            '/Users/rlaney/repos/Openstack_DevToolBox/horizon',
            '/Users/rlaney/repos/Openstack_DevToolBox/kolla',
            '/Users/rlaney/repos/Openstack_DevToolBox/magnum',
            '/Users/rlaney/repos/Openstack_DevToolBox/networking-cisco',
            '/Users/rlaney/repos/Openstack_DevToolBox/neutron',
            '/Users/rlaney/repos/Openstack_DevToolBox/tricircle',
            '/Users/rlaney/repos/osv-apps',
            '/Users/rlaney/repos/ovs',
            '/Users/rlaney/repos/ovs_lab',
            '/Users/rlaney/repos/oxidized',
            '/Users/rlaney/repos/pep8.org',
            '/Users/rlaney/repos/procs',
            '/Users/rlaney/repos/psycopg2',
            '/Users/rlaney/repos/pyandoc',
            '/Users/rlaney/repos/pyangbind',
            '/Users/rlaney/repos/pyflix2',
            '/Users/rlaney/repos/pynet',
            '/Users/rlaney/repos/PythonDropboxUploader',
            '/Users/rlaney/repos/rconfig',
            '/Users/rlaney/repos/recon-ng',
            '/Users/rlaney/repos/scapy',
            '/Users/rlaney/repos/showme',
            '/Users/rlaney/repos/tornado',
            '/Users/rlaney/repos/trigger',
            '/Users/rlaney/repos/trigger-repo',
            '/Users/rlaney/repos/virl-bootstrap',
            '/Users/rlaney/repos/virl-salt',
            '/Users/rlaney/repos/virl_boxcutter',
            '/Users/rlaney/repos/virl_cluster',
            '/Users/rlaney/repos/virl_packet',
            ]


with open('/Users/rlaney/Logs/my_projects.log', 'w') as log_file:
    try:
        for d in my_projects:
            retcode = call(git_add, cwd=d, shell=True)
            retcode = call(git_commit, cwd=d, shell=True)
            retcode = call(git_sync, cwd=d, shell=True)
            if retcode < 0:
                print >>sys.stderr, "Child was terminated by signal", -retcode
                print('Child was terminated by signal: {} \n'.format(-retcode))
                log_file.write('Child was terminated by signal: {} \n'.format(-retcode))
                print('~'*79 + '\n\n')
                log_file.write('~'*79 + '\n\n')
            else:
                print >>sys.stderr, "Child returned", retcode
                print('Success!! returned: {} \n'.format(retcode))
                print('~'*79 + '\n\n')
    except OSError, e:
        print >>sys.stderr, "Execution failed:", e
        print('Execution failed: {} \n'.format(e))
        log_file.write('Execution failed: {} \n'.format(e))
        print('~'*79 + '\n\n')
        log_file.write('~'*79 + '\n\n')


with open('/Users/rlaney/Logs/other_repos.log', 'w') as log_file:
    try:
        for d in other_repos:
            retcode = call(git_pull, cwd=d, shell=True)
            if retcode < 0:
                print >>sys.stderr, "Child was terminated by signal", -retcode
                print('Child was terminated by signal: {} \n'.format(-retcode))
                log_file.write('Child was terminated by signal: {} \n'.format(-retcode))
                print('~'*79 + '\n\n')
                log_file.write('~'*79 + '\n\n')
            elif retcode == 128:
                newcode = call(git_remote, cwd=d, stdout=log_file, stderr=STDOUT, shell=True)
                print >>sys.stderr, "Child was terminated by signal", -newcode
                log_file.write('Child was terminated by signal: {} \n'.format(-newcode))
                log_file.write('Repo location: {} \n'.format(d))
                print('~'*79 + '\n\n')
                log_file.write('~'*79 + '\n\n')
            else:
                print >>sys.stderr, "Child returned", retcode
                print('Success!! returned: {} \n'.format(retcode))
                print('~'*79 + '\n\n')
    except OSError, e:
        print >>sys.stderr, "Execution failed:", e
        print('Execution failed: {} \n'.format(e))
        log_file.write('Execution failed: {} \n'.format(e))
        print('~'*79 + '\n\n')
        log_file.write('~'*79 + '\n\n')
