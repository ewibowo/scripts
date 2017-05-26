#!/usr/bin/env python

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
            '/home/virl/.config-linux',
            '/home/virl/.dotfiles',
            '/home/virl/.tmux',
            '/home/virl/.tmuxinator',
            '/home/virl/.vim',
            '/home/virl/.zplug',
            '/home/virl/.zsh',
            '/home/virl/lib',
            '/home/virl/scripts',
            '/home/virl/vimwiki',
            ]



with open('/home/virl/Logs/my_projects.log', 'w+') as log_file:
    try:
        for d in my_projects:
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

