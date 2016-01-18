#!/bin/sh

find ~/.tmux/resurrect/* -mtime +2 -exec rm {} \;

exit
