#!/usr/bin/env python

import os
import subprocess
import time
import logging
import datetime


# make an easy print and logging function
def printLog(string):
    print '%s %s' % (datetime.datetime.now(), string)
    logging.info('%s %s' % (datetime.datetime.now(), string))

def check_dir_exist(os_dir):
    if not os.path.exists(os_dir):
        print os_dir, "does not exist."
        exit(1)

# Specify what and where to backup.
remote_path = raw_input("Please enter the remote path (<user>@<server>:<path>) \n")
file_type = raw_input("Please enter the file extension. No period needed! (log) \n")
the_files = "*." + file_type
remote_files = os.path.join(remote_path, the_files)
local_path = raw_input("Where you want to put these files?\n")
check_dir_exist(local_path)

# logging setup
logging.basicConfig(filename='%s' % os.path.join(local_path, '%s script.log' % datetime.datetime.now()),level=logging.DEBUG)

# Do the actual backup
print "Getting files..."

try:
    subprocess.Popen(['rsync', '-a', remote_files, local_path])
except:
    logging.exception("An exception occured")


#rsync("-az", remote_files, local_path)
# rsync subprocess
def rsyncFile(path):
    printLog("Syncing file '%s'" % os.path.basename(path))
    try:
        p = subprocess.Popen(['rsync', '-az', remote_files, local_path])
    except:
        logging.exception("An exception occured")


 main logic
def main():
    while True:
        files = [f for f in getFiles()]
        if len(files) == 1:
            printLog('<<< Found %s matching file >>>' % len(files))
        elif len(files) > 1:
            printLog('<<< Found %s matching files >>>' % len(files))
        for f in files:
            rsyncFile(f)
        printLog('No files found.')

if __name__ == "__main__":
    main()


# rsync subprocess
def rsyncFile(path):
    printLog("Syncing file '%s'" % os.path.basename(path))
    try:
        p = subprocess.Popen(['rsync', '-az', path, REM_DIR], stdout=subprocess.PIPE)
        for line in p.stdout:
            printLog("rsync: '%s'" %line)
        p.wait()
        printlog(
            {
                0  : '<<< File synced successfully :) >>>',
                10 : '****** Please check your network connection!! ******  Rsync error code: %s' % p.returncode,
            }.get(p.returncode, '****** Please check your network connection!! ******  Rsync error code: %s' % p.returncode) # A switch statement in python !
        )
    except:
        logging.exception("An exception occured")


def main():
    while True:
        files = [f for f in getFiles(LOC_DIR) if checkExt(f)]
        if len(files) == 1:
            printLog('<<< Found %s matching file >>>' % len(files))
        elif len(files) > 1:
            printLog('<<< Found %s matching files >>>' % len(files))
        for f in files:
            if checkSize(f):
                rsyncFile(f)
        printLog('No files found.  Checking again in %s seconds' % RUN_INT)
        time.sleep(RUN_INT)
        printLog('Checking for files')
