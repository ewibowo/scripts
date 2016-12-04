#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

from subprocess import call

progs = '''
blessings
bpython
curtsies
Cython
dnet
docker-py
docker-pycreds
greenlet
Jinja2
nose
pep8
powerline-docker
powerline-gitstatus
powerline-mem-segment
powerline-status
prettyprint
prompt-toolkit
psutil
python-dateutil
pyzmq
requests
scapy
vboxapi
virtualenv
virtualenv-clone
virtualenvwrapper
wcwidth
websocket-client
'''.split()

for p in progs:
    print('Uninstalling {}'.format(p))
    call(['pip', 'uninstall', p])
