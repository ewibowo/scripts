#!/usr/local/bin/python

'''
Program to update/push/pull all repos
To push my config or system related repos:
python repo-up.py -i users.csv -o users.json -f dump

To push my project repos:
python repo-up.py -i users.csv -o users.json -f pretty
'''

import getopt
import sys
from subprocess import *

sub_exceptions = (OSError,ValueError)

mess = "The git-update script pushed these"
git_add = ('git add -A')
git_commit = ('git commit -a -m "The git-update script pushed these"')
git_sync = ('git push -u origin master')

system_repos = [
            '/Users/rlaney/.atom',
            '/Users/rlaney/.config',
            '/Users/rlaney/.dotfiles',
            '/Users/rlaney/.tmux',
            '/Users/rlaney/.tmuxinator',
            '/Users/rlaney/.vim',
            '/Users/rlaney/.zplug',
            '/Users/rlaney/.zsh',
            '/Users/rlaney/scripts',
            '/Users/rlaney/vimwiki',
            '/Users/rlaney/repos/hosts',
            '/Users/rlaney/lib',
            ]


#try:
#    for d in system_repos:
#        output = Popen([commit, sync], cwd=d, shell=True)
#        print(output)
#except sub_exceptions as e:
#        print(e)

try:
    for d in system_repos:
        retcode = call(git_add, cwd=d, shell=True)
        retcode = call(git_commit, cwd=d, shell=True)
        retcode = call(git_sync, cwd=d, shell=True)
        if retcode < 0:
            print >>sys.stderr, "Child was terminated by signal", -retcode
        else:
            print >>sys.stderr, "Child returned", retcode
except OSError, e:
    print >>sys.stderr, "Execution failed:", e

##Get Command Line Arguments
#def main(sys.argv):
#    input_file = ''
#    output_file = ''
#    format = ''
#    try:
#        opts, args = getopt.getopt(argv,"hi:o:f:",["ifile=","ofile=","format="])
#    except getopt.GetoptError:
#        print 'csv_json.py -i <path to inputfile> -o <path to outputfile> -f <dump/pretty>'
#        sys.exit(2)
#    for opt, arg in opts:
#        if opt == '-h':
#            print 'csv_json.py -i <path to inputfile> -o <path to outputfile> -f <dump/pretty>'
#            sys.exit()
#        elif opt in ("-i", "--ifile"):
#            input_file = arg
#        elif opt in ("-o", "--ofile"):
#            output_file = arg
#        elif opt in ("-f", "--format"):
#            format = arg
#    read_csv(input_file, output_file, format)
#
#if __name__ == "__main__":
#   main(sys.argv[1:])
#
#
#alias gaa='git add -A'
#alias gcam='git commit -a -m'
#alias gpom='git push -u origin master'
#alias gacap='gaa && gcam "Auto Push" && gpom'
#git add -A && git commit -a -m "Git-update script pushed these" && git push -u origin master
#
#
#
## Projects
#~/Dropbox (Personal)/cheaters
#~/Projects/neteng1
#~/Projects/NetEngineerONE
#~/Projects/oxidized
#~/Projects/trigger
#~/Projects/VIRL_Projects
#
## Repos not owned by me
#~/Projects/NetEngineerONE/other/repos/django-wiki
#~/Projects/NetEngineerONE/other/repos/django-wiki-project-template
#~/Projects/NetEngineerONE/other/repos/GateOne
#~/Projects/NetEngineerONE/other/repos/netbox
#~/Projects/NetEngineerONE/other/repos/oxidized
#~/Projects/NetEngineerONE/other/repos/trigger
#~/Projects/Network_Automation/ansible-modules-core
#~/Projects/Network_Automation/ansible-modules-extras
#~/Projects/Network_Automation/bsn-ansible
#~/Projects/Network_Automation/napalm
#~/Projects/Network_Automation/napalm-ansible
#~/Projects/Network_Automation/Netmiko training
#~/Projects/Network_Automation/ntc-ansible
#~/Projects/Network_Automation/ntc-ansible-docs
#~/Projects/Network_Automation/ntc-templates
#~/Projects/Network_Automation/pyntc
#~/Projects/Network_Automation/pynxos
#~/Projects/Network_Automation/test-network-modules
#~/Projects/CiscoDevNet/aci-learning-labs
#~/Projects/CiscoDevNet/api-design-guide
#~/Projects/CiscoDevNet/apic-em-samples-aradford
#~/Projects/CiscoDevNet/apicem-ga-ll-sample-code
#~/Projects/CiscoDevNet/coding-skills-go
#~/Projects/CiscoDevNet/coding-skills-sample-code
#~/Projects/CiscoDevNet/cosc-learning-labs
#~/Projects/CiscoDevNet/cosc-rest-api-python
#~/Projects/CiscoDevNet/devnet-dev-vms
#~/Projects/CiscoDevNet/netconf-examples
#~/Projects/CiscoDevNet/NeXt
#~/Projects/CiscoDevNet/nxapi-learning-labs
#~/Projects/CiscoDevNet/nxos-ansible
#~/Projects/CiscoDevNet/nxos-examples
#~/Projects/CiscoDevNet/nxtoolkit
#~/Projects/CiscoDevNet/opendaylight-bootcamps
#~/Projects/CiscoDevNet/Opendaylight-Openflow-App
#~/Projects/CiscoDevNet/opendaylight-sample-apps
#~/Projects/CiscoDevNet/opendaylight-setup
#~/Projects/CiscoDevNet/opennxos
#~/Projects/CiscoDevNet/OPNFV
#~/Projects/CiscoDevNet/pceof-gui
#~/Projects/CiscoDevNet/restconf-examples
#~/Projects/CiscoDevNet/uniq
#~/Projects/CiscoDevNet/vpp-odl
#~/Projects/CiscoDevNet/yang-examples
#~/Projects/CiscoDevNet/yang-explorer
#~/Projects/CiscoDevNet/yangman
#~/Projects/CiscoDevNet/ydk-gen
#~/Projects/CiscoDevNet/ydk-gen-bundles
#~/Projects/CiscoDevNet/ydk-py
#~/Projects/CiscoDevNet/ydk-py-samples
#~/Projects/GateOne
#~/Projects/Openstack_DevToolBox/app-catalog-ui
#~/Projects/pynet
#~/Projects/Python/PythonDropboxUploader
#~/Projects/python-guide
#~/Projects/recon/recon-ng
#~/Projects/SNMP
#~/Projects/tornado
#~/Projects/trigger-dev
