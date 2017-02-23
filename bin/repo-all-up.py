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

system_repos = [
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
            ]

my_projects = [
            '/Users/rlaney/Dropbox (Personal)/cheaters',
            '/Users/rlaney/Projects/VIRL_Projects',
            '/Users/rlaney/Projects/ansible',
            '/Users/rlaney/Projects/trigger',
            '/Users/rlaney/.virtualenvs/neteng/project',
            '/Users/rlaney/Projects/NetEngineerONE',
            ]

other_repos = [
            '/Users/rlaney/Projects/APIs/ax_metrics',
            '/Users/rlaney/Projects/APIs/grequests',
            '/Users/rlaney/Projects/APIs/records',
            '/Users/rlaney/Projects/APIs/requests',
            '/Users/rlaney/Projects/APIs/wwwclient',
            '/Users/rlaney/Projects/AzureAPIs/azure-sdk-for-python',
            '/Users/rlaney/Projects/AzureAPIs/python-azureml-client',
            '/Users/rlaney/Projects/CiscoDevNet/ACI',
            '/Users/rlaney/Projects/CiscoDevNet/Ansible-NXOS',
            '/Users/rlaney/Projects/CiscoDevNet/FabricResourceCalculation',
            '/Users/rlaney/Projects/CiscoDevNet/NeXt',
            '/Users/rlaney/Projects/CiscoDevNet/OPNFV',
            '/Users/rlaney/Projects/CiscoDevNet/Opendaylight-Openflow-App',
            '/Users/rlaney/Projects/CiscoDevNet/PyMonitor',
            '/Users/rlaney/Projects/CiscoDevNet/UCS',
            '/Users/rlaney/Projects/CiscoDevNet/aci-ansible',
            '/Users/rlaney/Projects/CiscoDevNet/aci-diff',
            '/Users/rlaney/Projects/CiscoDevNet/aci-examples',
            '/Users/rlaney/Projects/CiscoDevNet/aci-export',
            '/Users/rlaney/Projects/CiscoDevNet/aci-fabric-deploy',
            '/Users/rlaney/Projects/CiscoDevNet/aci-fault-doc',
            '/Users/rlaney/Projects/CiscoDevNet/aci-learning-labs',
            '/Users/rlaney/Projects/CiscoDevNet/aci-vigilante',
            '/Users/rlaney/Projects/CiscoDevNet/acifabriclib',
            '/Users/rlaney/Projects/CiscoDevNet/acitoolkit',
            '/Users/rlaney/Projects/CiscoDevNet/api-design-guide',
            '/Users/rlaney/Projects/CiscoDevNet/apic-em-samples-aradford',
            '/Users/rlaney/Projects/CiscoDevNet/apicem-ga-ll-sample-code',
            '/Users/rlaney/Projects/CiscoDevNet/arya',
            '/Users/rlaney/Projects/CiscoDevNet/cobra',
            '/Users/rlaney/Projects/CiscoDevNet/coding-skills-go',
            '/Users/rlaney/Projects/CiscoDevNet/coding-skills-sample-code',
            '/Users/rlaney/Projects/CiscoDevNet/cosc-learning-labs',
            '/Users/rlaney/Projects/CiscoDevNet/cosc-rest-api-python',
            '/Users/rlaney/Projects/CiscoDevNet/devnet-dev-vms',
            '/Users/rlaney/Projects/CiscoDevNet/ignite',
            '/Users/rlaney/Projects/CiscoDevNet/itopo',
            '/Users/rlaney/Projects/CiscoDevNet/link-state-monitor',
            '/Users/rlaney/Projects/CiscoDevNet/netconf-examples',
            '/Users/rlaney/Projects/CiscoDevNet/nexus5000',
            '/Users/rlaney/Projects/CiscoDevNet/nexus7000',
            '/Users/rlaney/Projects/CiscoDevNet/nxapi-learning-labs',
            '/Users/rlaney/Projects/CiscoDevNet/nxos',
            '/Users/rlaney/Projects/CiscoDevNet/nxos-ansible',
            '/Users/rlaney/Projects/CiscoDevNet/nxos-examples',
            '/Users/rlaney/Projects/CiscoDevNet/nxtoolkit',
            '/Users/rlaney/Projects/CiscoDevNet/open-nxos-getting-started',
            '/Users/rlaney/Projects/CiscoDevNet/opendaylight-bootcamps',
            '/Users/rlaney/Projects/CiscoDevNet/opendaylight-sample-apps',
            '/Users/rlaney/Projects/CiscoDevNet/opendaylight-setup',
            '/Users/rlaney/Projects/CiscoDevNet/opennxos',
            '/Users/rlaney/Projects/CiscoDevNet/pceof-gui',
            '/Users/rlaney/Projects/CiscoDevNet/perf-automation',
            '/Users/rlaney/Projects/CiscoDevNet/pyaci',
            '/Users/rlaney/Projects/CiscoDevNet/restconf-examples',
            '/Users/rlaney/Projects/CiscoDevNet/uniq',
            '/Users/rlaney/Projects/CiscoDevNet/vpp-odl',
            '/Users/rlaney/Projects/CiscoDevNet/who-moved-my-cli',
            '/Users/rlaney/Projects/CiscoDevNet/yang-examples',
            '/Users/rlaney/Projects/CiscoDevNet/yang-explorer',
            '/Users/rlaney/Projects/CiscoDevNet/yangman',
            '/Users/rlaney/Projects/CiscoDevNet/ydk-gen',
            '/Users/rlaney/Projects/CiscoDevNet/ydk-gen-bundles',
            '/Users/rlaney/Projects/CiscoDevNet/ydk-py',
            '/Users/rlaney/Projects/CiscoDevNet/ydk-py-samples',
            '/Users/rlaney/Projects/GateOne',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/GateOne',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/django-wiki',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/django-wiki-project-template',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/netbox',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/oxidized',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/rconfig',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/trigger',
            '/Users/rlaney/Projects/Network_Automation/Automation',
            '/Users/rlaney/Projects/Network_Automation/NetSpark-Scripts',
            '/Users/rlaney/Projects/Network_Automation/Netmiko training',
            '/Users/rlaney/Projects/Network_Automation/NetworkAutomation',
            '/Users/rlaney/Projects/Network_Automation/NetworkAutomationProject',
            '/Users/rlaney/Projects/Network_Automation/NetworkAutomationUsingPython',
            '/Users/rlaney/Projects/Network_Automation/ansible-trigger',
            '/Users/rlaney/Projects/Network_Automation/autonet',
            '/Users/rlaney/Projects/Network_Automation/bgpranking-redis-api',
            '/Users/rlaney/Projects/Network_Automation/bosun',
            '/Users/rlaney/Projects/Network_Automation/bsn-ansible',
            '/Users/rlaney/Projects/Network_Automation/cisco_netmiko',
            '/Users/rlaney/Projects/Network_Automation/cpauto',
            '/Users/rlaney/Projects/Network_Automation/cpcloud',
            '/Users/rlaney/Projects/Network_Automation/dns-crawl',
            '/Users/rlaney/Projects/Network_Automation/napalm',
            '/Users/rlaney/Projects/Network_Automation/napalm-ansible',
            '/Users/rlaney/Projects/Network_Automation/net-config',
            '/Users/rlaney/Projects/Network_Automation/netman',
            '/Users/rlaney/Projects/Network_Automation/netmiko',
            '/Users/rlaney/Projects/Network_Automation/netmiko-ansible',
            '/Users/rlaney/Projects/Network_Automation/netmiko-cisco-playground',
            '/Users/rlaney/Projects/Network_Automation/netmiko-ppaskowsky',
            '/Users/rlaney/Projects/Network_Automation/netmiko_test',
            '/Users/rlaney/Projects/Network_Automation/netmiko_tools',
            '/Users/rlaney/Projects/Network_Automation/network-automation',
            '/Users/rlaney/Projects/Network_Automation/ntc-ansible',
            '/Users/rlaney/Projects/Network_Automation/ntc-ansible-docs',
            '/Users/rlaney/Projects/Network_Automation/ntc-templates',
            '/Users/rlaney/Projects/Network_Automation/pyntc',
            '/Users/rlaney/Projects/Network_Automation/pynxos',
            '/Users/rlaney/Projects/Network_Automation/test-network-modules',
            '/Users/rlaney/Projects/Openstack_DevToolBox/dragonflow',
            '/Users/rlaney/Projects/Openstack_DevToolBox/grafyaml',
            '/Users/rlaney/Projects/Openstack_DevToolBox/kolla',
            '/Users/rlaney/Projects/Openstack_DevToolBox/magnum',
            '/Users/rlaney/Projects/Openstack_DevToolBox/tricircle',
            '/Users/rlaney/Projects/Python/PythonDropboxUploader',
            '/Users/rlaney/Projects/VIRL/virl-bootstrap',
            '/Users/rlaney/Projects/VIRL/virl-salt',
            '/Users/rlaney/Projects/VIRL/virl_boxcutter',
            '/Users/rlaney/Projects/VIRL/virl_cluster',
            '/Users/rlaney/Projects/VIRL/virl_packet',
            '/Users/rlaney/Projects/ansible/repo-odl',
            '/Users/rlaney/Projects/ansible/repo-osa',
            '/Users/rlaney/Projects/aws-transit-vpc',
            '/Users/rlaney/Projects/django-todo',
            '/Users/rlaney/Projects/dotfiles',
            '/Users/rlaney/Projects/ghsync',
            '/Users/rlaney/Projects/het-ansible/utils/NetSpark-Scripts',
            '/Users/rlaney/Projects/het-ansible/utils/NetworkAutomation',
            '/Users/rlaney/Projects/het-ansible/utils/acitoolkit',
            '/Users/rlaney/Projects/het-ansible/utils/ansible-trigger',
            '/Users/rlaney/Projects/het-ansible/utils/autonet',
            '/Users/rlaney/Projects/het-ansible/utils/bsn-ansible',
            '/Users/rlaney/Projects/het-ansible/utils/cisco_netmiko',
            '/Users/rlaney/Projects/het-ansible/utils/dns-crawl',
            '/Users/rlaney/Projects/het-ansible/utils/napalm',
            '/Users/rlaney/Projects/het-ansible/utils/napalm-ansible',
            '/Users/rlaney/Projects/het-ansible/utils/net-config',
            '/Users/rlaney/Projects/het-ansible/utils/netman',
            '/Users/rlaney/Projects/het-ansible/utils/netmiko',
            '/Users/rlaney/Projects/het-ansible/utils/netmiko-ansible',
            '/Users/rlaney/Projects/het-ansible/utils/netmiko_tools',
            '/Users/rlaney/Projects/het-ansible/utils/ntc-ansible',
            '/Users/rlaney/Projects/het-ansible/utils/ntc-ansible-docs',
            '/Users/rlaney/Projects/het-ansible/utils/ntc-templates',
            '/Users/rlaney/Projects/het-ansible/utils/pyntc',
            '/Users/rlaney/Projects/het-ansible/utils/pynxos',
            '/Users/rlaney/Projects/het-ansible/utils/test-network-modules',
            '/Users/rlaney/Projects/newspaper',
            '/Users/rlaney/Projects/osv-apps',
            '/Users/rlaney/Projects/ovs',
            '/Users/rlaney/Projects/oxidized',
            '/Users/rlaney/Projects/pep8.org',
            '/Users/rlaney/Projects/procs',
            '/Users/rlaney/Projects/psycopg2',
            '/Users/rlaney/Projects/py-snmp/SNMP',
            '/Users/rlaney/Projects/pyandoc',
            '/Users/rlaney/Projects/pyflix2',
            '/Users/rlaney/Projects/pynet',
            '/Users/rlaney/Projects/recon/recon-ng',
            '/Users/rlaney/Projects/showme',
            '/Users/rlaney/Projects/tornado',
            '/Users/rlaney/Projects/trigger-repo',
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
            '/Users/rlaney/repos/LinuxONLY/blueprint',
            ]


with open('/Users/rlaney/Logs/system_repos.log', 'w') as log_file:
    try:
        for d in system_repos:
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
            if retcode == 128:
                print >>sys.stderr, "Child was terminated by signal", -retcode
                print('Child was terminated by signal: {} \n'.format(-retcode))
                log_file.write('Child was terminated by signal: {} \n'.format(-retcode))
                log_file.write('Repo location: {} \n'.format(d))
                log_file.write("Standard in: {} \n".format(str(sys.stdin)))
                log_file.write("Standard out: {} \n".format(str(sys.stdout)))
                log_file.write("Standard error: {} \n".format(str(sys.stderr)))
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
