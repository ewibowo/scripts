#!/usr/bin/env sh

echo "Homebrew and Homebrew Cask Maintenance.  Updating, upgrading, and cleaning all brews."
brew update && brew upgrade && brew cleanup && brew cask cleanup

#echo "Looking for Homebrew problems using the Doctor and verbose maintenance."
#brew cask doctor --verbose

#brew update --verbose && brew upgrade brew-cask --verbose && brew cleanup --verbose && brew cask cleanup --verbose
