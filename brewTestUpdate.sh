#!/bin/zsh -f

NAME="$0:t:r"

export PATH=/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin

(#di-xquartz.sh && \
 brew update  && \
 brew upgrade && \
 brew doctor) 2>&1 |\
 	tee -a "$HOME/Library/Logs/$NAME.log"

exit 0
