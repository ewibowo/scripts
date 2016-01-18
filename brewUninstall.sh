#!/bin/sh

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  #if [ -w "$HOME/.zshrc.local" ]; then
    #zshrc="$HOME/.zshrc.local"
  #else
    zshrc="$HOME/.zshrc"
  #fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if [ ! -d "$HOME/.bin/" ]; then
  mkdir "$HOME/.bin"
fi

if [ ! -d "$HOME/.config/" ]; then
  mkdir "$HOME/.config"
fi

if [ ! -f "$HOME/.config/env.zsh" ]; then
  touch "$HOME/.config/env.zsh"
fi

if [ ! -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
fi

brew_uninstall() {
  if brew_is_installed "$1"; then
      fancy_echo "Uninstalling %s..." "$1"
      brew uninstall "$@"
  else
    fancy_echo "Not uninstalling because %s is not installed." "$1"
  fi
}

brew_is_installed() {
#  local name="$(brew_expand_alias "$1")"
  brew list -1 | grep -Fqx "$1"
}

brew_tap() {
  brew tap "$1" 2> /dev/null
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

#if ! command -v brew >/dev/null; then
#  fancy_echo "Installing Homebrew ..."
#    curl -fsS \
#      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
#    append_to_zshrc '# recommended by brew doctor'
    # shellcheck disable=SC2016
#    append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1
#    export PATH="/usr/local/bin:$PATH"
#else
#  fancy_echo "Homebrew already installed. Skipping ..."
#fi

brew_uninstall 'autoconf'
brew_uninstall 'coreutils'
brew_uninstall 'grep'
brew_uninstall 'openssl'
brew_uninstall 'pkg-config'
brew_uninstall 'rcm'
brew_uninstall 'ruby'
brew_uninstall 'tcpdump'
brew_uninstall 'awk'
brew_uninstall 'brew-cask'
brew_uninstall 'findutils'
brew_uninstall 'libyaml'
brew_uninstall 'pcre'
brew_uninstall 'rbenv'
brew_uninstall 'readline'
brew_uninstall 'ruby-build'

brew_uninstall 'ack'
brew_uninstall 'autoconf'
brew_uninstall 'autoenv'
brew_uninstall 'automake'
brew_uninstall 'awk'
brew_uninstall 'bash'
brew_uninstall 'boost'
brew_uninstall 'boost-python'
brew_uninstall 'brew-cask'
brew_uninstall 'coreutils'
brew_uninstall 'cscope'
brew_uninstall 'ctags'
brew_uninstall 'docker'
brew_uninstall 'docker-compose'
brew_uninstall 'docker-machine'
brew_uninstall 'findutils'
brew_uninstall 'fontconfig'
brew_uninstall 'freetype'
brew_uninstall 'gdbm'
brew_uninstall 'git'
brew_uninstall 'grep'
brew_uninstall 'heroku-toolbelt'
brew_uninstall 'highlight'
brew_uninstall 'hub'
brew_uninstall 'imagemagick'
brew_uninstall 'jpeg'
brew_uninstall 'libdnet'
brew_uninstall 'libevent'
brew_uninstall 'libgpg-error'
brew_uninstall 'libksba'
brew_uninstall 'libpng'
brew_uninstall 'libtiff'
brew_uninstall 'libtool'
brew_uninstall 'libyaml'
brew_uninstall 'lua'
brew_uninstall 'macvim'
brew_uninstall 'makedepend'
brew_uninstall 'markdown'
brew_uninstall 'nginx'
brew_uninstall 'node'
brew_uninstall 'nvm'
brew_uninstall 'openssl'
brew_uninstall 'packer'
brew_uninstall 'pcre'
brew_uninstall 'pkg-config'
brew_uninstall 'postgresql'
brew_uninstall 'pyenv'
brew_uninstall 'pyqt'
brew_uninstall 'python'
brew_uninstall 'python3'
brew_uninstall 'qt'
brew_uninstall 'rbenv'
brew_uninstall 'rbenv-default-gems'
brew_uninstall 'rbenv-gem-rehash'
brew_uninstall 'ruby-build'
brew_uninstall 'ruby'
brew_uninstall 'rcm'
brew_uninstall 'readline'
brew_uninstall 'reattach-to-user-namespace'
brew_uninstall 'redis'
brew_uninstall 'rename'
brew_uninstall 'ruby-build'
brew_uninstall 'sbt'
brew_uninstall 'scala'
brew_uninstall 'sip'
brew_uninstall 'sqlite'
brew_uninstall 'the_silver_searcher'
brew_uninstall 'tcpdump'
brew_uninstall 'tmux'
brew_uninstall 'tmuxinator-completion'
brew_uninstall 'trash'
brew_uninstall 'tree'
brew_uninstall 'wakeonlan'
brew_uninstall 'wget'
brew_uninstall 'xz'
brew_uninstall 'z'
brew_uninstall 'zeromq'
brew_uninstall 'zsh'
brew_uninstall 'zsh-completions'

fancy_echo "Updating Homebrew formulas ..."
brew update

