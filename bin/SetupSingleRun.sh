#!/bin/sh

# Welcome to the Ricky's laptop script!
# Be prepared to turn your laptop or desktop,
# into an awesome development machine.
##################################################
# Better install Xcode before running this!!
# To install Xcode command line tools:
#xcode-select --install
# Install Xquartz also. http://www.xquartz.org
##################################################
#           Run script to tweak OS X             #
##################################################

#echo "Running system tweeks with tweakosx.sh"
#source ./tweakosx.sh
#/bin/sh ./tweakosx.sh

# If not running tweakosx then:
echo "Ask for the administrator password upfront"
sudo -v

echo "Keep-alive: update existing sudo time stamp until tweekosx has finished"
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

##################################################
#               Define functions                 #
##################################################

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}

append_to_env() {
  local text="$1" env
  local skip_new_line="${2:-0}"
  env="$HOME/.config/env.sh"

  if ! grep -Fqs "$text" "$env"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\n" "$text" >> "$env"
    else
      printf "\n%s\n" "$text" >> "$env"
    fi
  fi
}

append_to_gemrc() {
  local text="$1" gemrc
  local skip_new_line="${2:-0}"
  gemrc="$HOME/.gemrc"

  if ! grep -Fqs "$text" "$gemrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\n" "$text" >> "$gemrc"
    else
      printf "\n%s\n" "$text" >> "$gemrc"
    fi
  fi
}

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set +e

##################################################
#             Homebrew functions                 #
##################################################

brew_install_or_upgrade() {
  if brew_is_installed "$1"; then
    if brew_is_upgradable "$1"; then
      fancy_echo "Upgrading %s ..." "$1"
      brew upgrade "$@"
    else
      fancy_echo "Already using the latest version of %s. Skipping ..." "$1"
    fi
  else
    fancy_echo "Installing %s ..." "$1"
    brew install "$@"
  fi
}

brew_is_installed() {
  local name="$(brew_expand_alias "$1")"
  brew list -1 | grep -Fqx "$name"
}

brew_is_upgradable() {
  local name="$(brew_expand_alias "$1")"
  ! brew outdated --quiet "$name" >/dev/null
}

brew_tap() {
  brew tap "$1" 2> /dev/null
}

brew_expand_alias() {
  brew info "$1" 2>/dev/null | head -1 | awk '{gsub (/:/, ""); print $1}'
}

brew_launchctl_restart() {
  local name="$(brew_expand_alias "$1")"
  local domain="homebrew.mxcl.$name"
  local plist="$domain.plist"
  fancy_echo "Restarting %s ..." "$1"
  mkdir -p "$HOME/Library/LaunchAgents"
  ln -sfv "/usr/local/opt/$name/$plist" "$HOME/Library/LaunchAgents"

  if launchctl list | grep -Fq "$domain"; then
    launchctl unload "$HOME/Library/LaunchAgents/$plist" >/dev/null
  fi
  launchctl load "$HOME/Library/LaunchAgents/$plist" >/dev/null
}

##################################################
#             Ruby Gem functions                 #
##################################################

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    fancy_echo "Updating %s ..." "$1"
    gem update "$@"
  else
    fancy_echo "Installing %s ..." "$1"
    gem install "$@"
    rbenv rehash
  fi
}

##################################################
#             Brew Cask functions                #
##################################################

brew_cask_install_or_upgrade() {
  if brew_cask_is_installed "$1"; then
    if brew_cask_is_upgradable "$1"; then
      fancy_echo "Upgrading %s ..." "$1"
      brew cask upgrade "$@"
    else
      fancy_echo "Already using the latest version of %s. Skipping ..." "$1"
    fi
  else
    fancy_echo "brew cask installing application %s ..." "$1"
    brew cask install "$@"
  fi
}

brew_cask_is_installed() {
  local name="$(brew_cask_expand_alias "$1")"
  brew cask list -1 | grep -Fqx "$name"
}

brew_cask_is_upgradable() {
  local name="$(brew_cask_expand_alias "$1")"
  ! brew cask outdated --quiet "$name" >/dev/null
}

brew_cask_expand_alias() {
  brew cask info "$1" 2>/dev/null | head -1 | awk '{gsub(/:/, ""); print $1}'
}

##################################################
#             Add Apps to Install                #
##################################################


brew install python --universal --framework
brew install python3 --universal --framework
brew install macvim --env-std --with-override-system-vim
brew linkapps
brew update
brew upgrade
brew cask update
brew cleanup
brew cask cleanup
brew doctor
brew cask doctor
brew cask audit

#brew_cask_install_or_upgrade 'gitbook'
#brew_cask_install_or_upgrade 'github'
#brew_cask_install_or_upgrade 'near-lock'
#brew_cask_install_or_upgrade 'dash'
#brew_cask_install_or_upgrade 'java'
#brew_cask_install_or_upgrade 'qq'
#brew_cask_install_or_upgrade 'flashlight'
#brew_cask_install_or_upgrade 'sequel-pro'
#brew_cask_install_or_upgrade 'tunnelblick'
#brew_cask_install_or_upgrade 'hammerspoon'
#brew_cask_install_or_upgrade 'sogouinput'
#brew_cask_install_or_upgrade 'qlimagesize'
#brew_cask_install_or_upgrade 'sourcetree'
#brew_install_or_upgrade 'automake'
#brew_install_or_upgrade 'awk'
#brew_install_or_upgrade 'tmuxinator-completion'
#brew_install_or_upgrade 'z'
#gem update --system
#brew update
#brew cask update
