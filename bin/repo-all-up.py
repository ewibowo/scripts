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
            '/Users/rlaney/scripts',
            '/Users/rlaney/vimwiki'
            ]

my_projects = [
            '/Users/rlaney/Dropbox\ \(Personal\)/cheaters',
            '/Users/rlaney/Projects/neteng1',
            '/Users/rlaney/Projects/NetEngineerONE',
            '/Users/rlaney/Projects/oxidized',
            '/Users/rlaney/Projects/trigger',
            '/Users/rlaney/Projects/VIRL_Projects',
            '/Users/rlaney/Projects/SNMP'
            ]

other_repos = [
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/django-wiki',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/django-wiki-project-template',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/GateOne',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/netbox',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/oxidized',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/rconfig',
            '/Users/rlaney/Projects/NetEngineerONE/other/repos/trigger',
            '/Users/rlaney/Projects/Network_Automation/bsn-ansible',
            '/Users/rlaney/Projects/Network_Automation/napalm',
            '/Users/rlaney/Projects/Network_Automation/napalm-ansible',
            '/Users/rlaney/Projects/Network_Automation/Netmiko training',
            '/Users/rlaney/Projects/Network_Automation/ntc-ansible',
            '/Users/rlaney/Projects/Network_Automation/ntc-ansible-docs',
            '/Users/rlaney/Projects/Network_Automation/ntc-templates',
            '/Users/rlaney/Projects/Network_Automation/pyntc',
            '/Users/rlaney/Projects/Network_Automation/pynxos',
            '/Users/rlaney/Projects/Network_Automation/test-network-modules',
            '/Users/rlaney/Projects/CiscoDevNet/aci-learning-labs',
            '/Users/rlaney/Projects/CiscoDevNet/api-design-guide',
            '/Users/rlaney/Projects/CiscoDevNet/apic-em-samples-aradford',
            '/Users/rlaney/Projects/CiscoDevNet/apicem-ga-ll-sample-code',
            '/Users/rlaney/Projects/CiscoDevNet/coding-skills-go',
            '/Users/rlaney/Projects/CiscoDevNet/coding-skills-sample-code',
            '/Users/rlaney/Projects/CiscoDevNet/cosc-learning-labs',
            '/Users/rlaney/Projects/CiscoDevNet/cosc-rest-api-python',
            '/Users/rlaney/Projects/CiscoDevNet/devnet-dev-vms',
            '/Users/rlaney/Projects/CiscoDevNet/netconf-examples',
            '/Users/rlaney/Projects/CiscoDevNet/NeXt',
            '/Users/rlaney/Projects/CiscoDevNet/nxapi-learning-labs',
            '/Users/rlaney/Projects/CiscoDevNet/nxos-ansible',
            '/Users/rlaney/Projects/CiscoDevNet/nxos-examples',
            '/Users/rlaney/Projects/CiscoDevNet/nxtoolkit',
            '/Users/rlaney/Projects/CiscoDevNet/opendaylight-bootcamps',
            '/Users/rlaney/Projects/CiscoDevNet/Opendaylight-Openflow-App',
            '/Users/rlaney/Projects/CiscoDevNet/opendaylight-sample-apps',
            '/Users/rlaney/Projects/CiscoDevNet/opendaylight-setup',
            '/Users/rlaney/Projects/CiscoDevNet/opennxos',
            '/Users/rlaney/Projects/CiscoDevNet/OPNFV',
            '/Users/rlaney/Projects/CiscoDevNet/pceof-gui',
            '/Users/rlaney/Projects/CiscoDevNet/restconf-examples',
            '/Users/rlaney/Projects/CiscoDevNet/uniq',
            '/Users/rlaney/Projects/CiscoDevNet/vpp-odl',
            '/Users/rlaney/Projects/CiscoDevNet/yang-examples',
            '/Users/rlaney/Projects/CiscoDevNet/yang-explorer',
            '/Users/rlaney/Projects/CiscoDevNet/yangman',
            '/Users/rlaney/Projects/CiscoDevNet/ydk-gen',
            '/Users/rlaney/Projects/CiscoDevNet/ydk-gen-bundles',
            '/Users/rlaney/Projects/CiscoDevNet/ydk-py',
            '/Users/rlaney/Projects/CiscoDevNet/ydk-py-samples',
            '/Users/rlaney/Projects/GateOne',
            '/Users/rlaney/Projects/Openstack_DevToolBox/dragonflow',
            '/Users/rlaney/Projects/Openstack_DevToolBox/grafyaml',
            '/Users/rlaney/Projects/Openstack_DevToolBox/kolla',
            '/Users/rlaney/Projects/Openstack_DevToolBox/magnum',
            '/Users/rlaney/Projects/pynet',
            '/Users/rlaney/Projects/Python/PythonDropboxUploader',
            '/Users/rlaney/Projects/recon/recon-ng',
            '/Users/rlaney/Projects/tornado',
            '/Users/rlaney/Projects/trigger-dev'
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
                print('Child returned: {} \n'.format(retcode))
                log_file.write('Child returned: {} \n'.format(retcode))
                print('~'*79 + '\n\n')
                log_file.write('~'*79 + '\n\n')
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
                print('Child returned: {} \n'.format(retcode))
                log_file.write('Child returned: {} \n'.format(retcode))
                print('~'*79 + '\n\n')
                log_file.write('~'*79 + '\n\n')
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
            else:
                print >>sys.stderr, "Child returned", retcode
                print('Child returned: {} \n'.format(retcode))
                log_file.write('Child returned: {} \n'.format(retcode))
                print('~'*79 + '\n\n')
                log_file.write('~'*79 + '\n\n')
    except OSError, e:
        print >>sys.stderr, "Execution failed:", e
        print('Execution failed: {} \n'.format(e))
        log_file.write('Execution failed: {} \n'.format(e))
        print('~'*79 + '\n\n')
        log_file.write('~'*79 + '\n\n')




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
