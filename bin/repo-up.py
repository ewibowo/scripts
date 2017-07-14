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
git_sync_master = ('git push -u origin master')

my_projects_master = [
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
            '/Users/rlaney/Dropbox (Personal)/cheaters',
            '/Users/rlaney/Projects/VIRL_Projects',
            '/Users/rlaney/Projects/myansible',
            '/Users/rlaney/Projects/het-ansible',
            '/Users/rlaney/Projects/hosts',
            '/Users/rlaney/Projects/trigger',
            '/Users/rlaney/Projects/oxidized',
            '/Users/rlaney/Projects/NetEngineerONE',
            '/Users/rlaney/Projects/py-snmp',
            '/Users/rlaney/.virtualenvs/neteng/project',
            ]


with open('/Users/rlaney/Logs/my_projects.log', 'w') as log_file:
    try:
        for d in my_projects_master:
            retcode = call(git_add, cwd=d, shell=True)
            retcode = call(git_commit, cwd=d, shell=True)
            retcode = call(git_sync_master, cwd=d, shell=True)
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
#        for d in my_projects_osx:
#            retcode = call(git_add, cwd=d, shell=True)
#            retcode = call(git_commit, cwd=d, shell=True)
#            retcode = call(git_sync_osx, cwd=d, shell=True)
#            if retcode < 0:
#                print >>sys.stderr, "Child was terminated by signal", -retcode
#                print('Child was terminated by signal: {} \n'.format(-retcode))
#                log_file.write('Child was terminated by signal: {} \n'.format(-retcode))
#                print('~'*79 + '\n\n')
#                log_file.write('~'*79 + '\n\n')
#            else:
#                print >>sys.stderr, "Child returned", retcode
#                print('Success!! returned: {} \n'.format(retcode))
#                print('~'*79 + '\n\n')
    except OSError, e:
        print >>sys.stderr, "Execution failed:", e
        print('Execution failed: {} \n'.format(e))
        log_file.write('Execution failed: {} \n'.format(e))
        print('~'*79 + '\n\n')
        log_file.write('~'*79 + '\n\n')

'''
Below are repos I am interested in but do not own.
'''

git_pull = ('git pull')
git_remote = ('git remote show origin')
repos = '/Users/rlaney/repos'
find_git = ('find . -type d -name .git -print')
find_docker = ('find . -type f \( -name "Dockerfile*" -o -name "docker-compose*" \) -print')
find_docker_file = ('find . -type f -name Dockerfile* -print')
find_docker_compose = ('find . -type f -name docker-compose* -print')
repo_results = []
docker_results = []


with open('/Users/rlaney/repos/repo_list.nfo', 'w') as repo_file:
    repos_found = check_output(find_git, cwd=repos, shell=True)
    repos_found = repos_found.splitlines()
    for r in repos_found:
        r = r.lstrip('.').rsplit('/.git')[0]
        r = repos + r
        repo_file.write(r + '\n')
        repo_results.append(r)


with open('/Users/rlaney/repos/docker_files.nfo', 'w') as docker_file:
    docker_found = check_output(find_docker, cwd=repos, shell=True)
    docker_found = docker_found.splitlines()
    for k in docker_found:
        k = k.lstrip('.')
        k = repos + k
        docker_file.write(k + '\n')


with open('/Users/rlaney/Logs/repos_pull.log', 'w') as log_file:
    try:
        for d in repo_results:
            retcode = call(git_pull, cwd=d, shell=True)
            if retcode == 0:
                print >>sys.stderr, "Child returned", retcode
                print('Success!! returned: {} \n'.format(retcode))
                print('~'*79 + '\n\n')
            elif retcode == 128:
                newcode = call(git_remote, cwd=d, stdout=log_file, stderr=STDOUT, shell=True)
                print >>sys.stderr, "Child was terminated by signal", -newcode
                log_file.write('Child was terminated by signal: {} \n'.format(-newcode))
                log_file.write('Repo location: {} \n'.format(d))
                print('~'*79 + '\n\n')
                log_file.write('~'*79 + '\n\n')
            else:
                print >>sys.stderr, "Child was terminated by signal", -retcode
                print('Child was terminated by signal: {} \n'.format(-retcode))
                log_file.write('Child was terminated by signal: {} \n'.format(-retcode))
                print('~'*79 + '\n\n')
                log_file.write('~'*79 + '\n\n')
    except OSError, e:
        print >>sys.stderr, "Execution failed:", e
        print('Execution failed: {} \n'.format(e))
        log_file.write('Execution failed: {} \n'.format(e))
        print('~'*79 + '\n\n')
        log_file.write('~'*79 + '\n\n')


'''
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
'''
