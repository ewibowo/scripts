#!/bin/zsh -f

NAME="$0:t:r"

export PATH=/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin

(brew update && \
 brew upgrade && \
 brew cask update && \
 brew linkapps && \
 brew cleanup && \
 brew cask cleanup && \
 brew doctor && \
 brew cask doctor && \
 brew cask audit ) 2>&1 |\
 	tee -a "$HOME/Logs/$NAME.log"

exit 0

# List commands:
#brew linkapps
#brew update
#brew upgrade
#brew cask update
#brew cleanup
#brew cask cleanup
#brew doctor
#brew cask doctor
#brew cask audit
