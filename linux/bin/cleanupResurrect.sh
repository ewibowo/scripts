#!/bin/sh

find /Users/rlaney/.tmux/resurrect/* -type f -mtime +2 -exec rm {} \;

exit
