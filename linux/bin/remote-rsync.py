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

def confirm():
    gogo = raw_input("Continue? yes/no\n")
    global exit_condition
    if gogo == 'yes':
        exit_condition = 0
        return exit_condition
    elif gogo == "no":
        exit_condition = 1
        return exit_condition
    else:
        print "Please answer with yes or no."
        confirm()

# Specify what and where to backup.
remote_path = raw_input("Please enter the remote path (<user>@<server>:<path>) \n")
file_type = raw_input("Please enter the file extension. No period needed! (log) \n")
the_files = "*." + file_type
remote_files = os.path.join(remote_path, the_files)
print("Getting files from: ", remote_files)

# get the files with absolute paths
#def getFiles(remote_path):
#    return [os.path.join(remote_path, the_files) for the_files in os.listdir(remote_path)]

time.sleep(3)

local_path = raw_input("Where you want to put these files?\n")
check_dir_exist(local_path)

# logging setup
logging.basicConfig(filename='%s' % os.path.join(local_path, '%s script.log' % datetime.datetime.now()),level=logging.DEBUG)

# Do the actual backup
print "Getting files..."
confirm()
if exit_condition == 1:
        print "Aborting!"
        exit(1)

#rsync("-az", remote_files, local_path)
# rsync subprocess
def rsyncFile(path):
    printLog("Syncing file '%s'" % os.path.basename(path))
    try:
        p = subprocess.Popen('rsync', '-az', remote_files, local_path)
    except:
        logging.exception("An exception occured")


# main logic
#def main():
#    while True:
#        files = [f for f in getFiles()]
#        if len(files) == 1:
#            printLog('<<< Found %s matching file >>>' % len(files))
#        elif len(files) > 1:
#            printLog('<<< Found %s matching files >>>' % len(files))
#        for f in files:
#            rsyncFile(f)
#        printLog('No files found.')
#
#if __name__ == "__main__":
#    main()
