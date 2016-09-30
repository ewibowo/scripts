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
#source ~/bin/tweakosx.sh
#/bin/sh ./tweakosx.sh

#echo "Running system tweeks with .macos"
#source ./.macos
#/bin/sh ./.macos

# If not running tweakosx or macos then:
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

if [ ! -d "$HOME/bin/" ]; then
  mkdir "$HOME/bin"
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

if [ ! -f "$HOME/.gemrc" ]; then
  touch "$HOME/.gemrc"
fi

# shellcheck disable=SC2016
append_to_env 'export PATH="$HOME/bin:$PATH"'

case "$SHELL" in
  */zsh) : ;;
  *)
    fancy_echo "Changing your shell to zsh ..."
      chsh -s "$(which zsh)"
    ;;
esac

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

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
    append_to_zshrc '# recommended by brew doctor'
    # shellcheck disable=SC2016
    append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1
    export PATH="/usr/local/bin:$PATH"
else
  fancy_echo "Homebrew already installed. Skipping ..."
fi

fancy_echo "Updating Homebrew formulas ..."
brew update

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
    fancy_echo "Brew Cask installing application %s ..." "$1"
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

if ! command -v brew cask >/dev/null; then
  fancy_echo "Installing Brew Cask ..."
    append_to_env '# User specified directories.  Can be overriden with local command.' 1
    append_to_env 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"' 1
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"    
    brew install caskroom/cask/brew-cask
else
  fancy_echo "Brew Cask already installed. Skipping ..."
  append_to_env '# User specified directories.  Can be overriden with local command.' 1
  append_to_env 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"' 1
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"
fi

fancy_echo "Updating Brew Cask formulas ..."
brew cask update

##################################################
#             Ruby Gem functions                 #
##################################################

#brew_install_or_upgrade 'ruby'
#brew_install_or_upgrade 'rbenv'
#brew_install_or_upgrade 'ruby-build'

# shellcheck disable=SC2016
#append_to_zshrc 'eval "$(rbenv init - --no-rehash zsh)"' 1

#ruby_version="$(curl -sSL http://ruby.thoughtbot.com/latest)"
#
#eval "$(rbenv init - zsh)"
#
#if ! rbenv versions | grep -Fq "$ruby_version"; then
#  rbenv install -s "$ruby_version"
#fi
#
#rbenv global "$ruby_version"
#rbenv shell "$ruby_version"
#
#gem update --system
#
#gem_install_or_update 'bundler'
#
#fancy_echo "Configuring Bundler ..."
#  number_of_cores=$(sysctl -n hw.ncpu)
#  bundle config --global jobs $((number_of_cores - 1))
#  echo 'bundler' >> "$HOME/.rbenv/default-gems"
#  append_to_gemrc 'gem: --no-document'
#
#gem_install_or_update 'jekyll'
#gem_install_or_update 'kramdown'
#gem_install_or_update 'rails'
#echo 'rails' >> "$HOME/.rbenv/default-gems"
#
#gem update --system

# Replaced with mr and vcsh!!
#if ! command -v rcup >/dev/null; then
#  brew_tap 'thoughtbot/formulae'
#  brew_install_or_upgrade 'rcm'
#fi

##################################################
#                Install XQuartz                 #
##################################################

#sh ./di-xquartz.sh

##################################################

#fancy_echo "Installing GNU core utilities (those that come with OS X are outdated)"
#brew install coreutils
#fancy_echo "Installing GNU find, locate, updatedb, and xargs, g-prefixed"
#brew install findutils
#fancy_echo "Installing Bash 4"
#brew install bash
#append_to_zshrc '# To use the new coreutils:' 1
#append_to_zshrc 'export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"' 1
#append_to_zshrc 'export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"' 1
#export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
#export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
#
#brew_tap 'homebrew/fuse'
#brew_tap 'samueljohn/python'
#brew_tap 'homebrew/science'
#brew_install_or_upgrade 'gcc'
#
#brew_tap 'homebrew/completions'
#brew_install_or_upgrade 'brew-cask-completion'
#brew_install_or_upgrade 'zsh'
#brew_install_or_upgrade 'zsh-completions'
#append_to_zshrc '# To activate zsh-completions, add the following to your .zshrc:' 1
#append_to_zshrc   '# fpath=(/usr/local/share/zsh-completions $fpath)' 1
#append_to_zshrc '# You may also need to force rebuild `zcompdump`:' 1
#append_to_zshrc   '# rm -f ~/.zcompdump; compinit' 1
#append_to_zshrc 'fpath=(/usr/local/share/zsh-completions $fpath)' 1
#
#fancy_echo "Applications Installed manually"
#brew install python --universal --framework
#brew install python3 --universal --framework
#brew_install_or_upgrade 'pyenv'
#brew_install_or_upgrade 'pyqt'
#brew_install_or_upgrade 'node'
#brew_install_or_upgrade 'nvm'
#
#if [ ! -d "$HOME/.nvm/" ]; then
#  mkdir "$HOME/.nvm"
#  append_to_zshrc 'export NVM_DIR="~/.nvm"' 1
#  append_to_zshrc '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' 1
#fi
#
#npm install -g coffee-script
#npm install -g grunt-cli
#
#brew_install_or_upgrade 'openssl'
#brew unlink openssl && brew link openssl --force
#brew_install_or_upgrade 'libdnet'
#brew_install_or_upgrade 'libevent'
#brew_install_or_upgrade 'libpng'
#brew_install_or_upgrade 'libyaml'
#
#brew_install_or_upgrade 'postgresql'
##brew_launchctl_restart 'postgresql'
#brew_install_or_upgrade 'redis'
##brew_launchctl_restart 'redis'
#brew_install_or_upgrade 'sqlite'
#brew_install_or_upgrade 'mongodb --with-openssl'
##brew_launchctl_restart 'mongodb' # Prefer manual start & stop.
#
#brew_install_or_upgrade 'cscope'
#brew_install_or_upgrade 'lua'
#
##brew_install_or_upgrade 'autoconf'
##brew_install_or_upgrade 'ansible'
#brew_install_or_upgrade 'arpscan'
#brew_install_or_upgrade 'autoconf'
#brew_install_or_upgrade 'autoenv'
#brew_install_or_upgrade 'automake'
#brew_install_or_upgrade 'bison'
#brew_install_or_upgrade 'boost'
#brew_install_or_upgrade 'boost-python'
#brew_install_or_upgrade 'cairo'
#brew_install_or_upgrade 'cmake'
#brew_install_or_upgrade 'coreutils'
#brew_install_or_upgrade 'cscope'
#brew_install_or_upgrade 'ctags'
#brew_install_or_upgrade 'docker'
#brew_install_or_upgrade 'docker-cloud'
#brew_install_or_upgrade 'docker-compose'
#brew_install_or_upgrade 'docker-gen'
#brew_install_or_upgrade 'docker-machine'
#brew_install_or_upgrade 'docker-swarm'
#brew_install_or_upgrade 'dockviz'
#brew_install_or_upgrade 'fabric'
#brew_install_or_upgrade 'fdupes'
#brew_install_or_upgrade 'ffmpeg'
#brew_install_or_upgrade 'findutils'
#brew_install_or_upgrade 'fontconfig'
#brew_install_or_upgrade 'fping'
#brew_install_or_upgrade 'freetype'
#brew_install_or_upgrade 'gdbm'
#brew_install_or_upgrade 'gettext'
#brew_install_or_upgrade 'ghostscript'
#brew_install_or_upgrade 'git'
#brew_install_or_upgrade 'glib'
#brew_install_or_upgrade 'gmp'
#brew_install_or_upgrade 'gnutls'
#brew_install_or_upgrade 'go'
#brew_install_or_upgrade 'gobject-introspection'
#brew_install_or_upgrade 'graphviz'
#brew_install_or_upgrade 'gstreamer'
#brew_install_or_upgrade 'heroku'
#brew_install_or_upgrade 'heroku-toolbelt'
#brew_install_or_upgrade 'highlight'
#brew_install_or_upgrade 'hub'
#brew_install_or_upgrade 'i2p'
#brew_install_or_upgrade 'imagemagick'
#brew_install_or_upgrade 'iperf3'
#brew_install_or_upgrade 'ipinfo'
#brew_install_or_upgrade 'iproute2mac'
#brew_install_or_upgrade 'isl'
#brew_install_or_upgrade 'jpeg'
#brew_install_or_upgrade 'lame'
#brew_install_or_upgrade 'libffi'
#brew_install_or_upgrade 'libmpc'
#brew_install_or_upgrade 'libsmi'
#brew_install_or_upgrade 'libtasn1'
#brew_install_or_upgrade 'libtiff'
#brew_install_or_upgrade 'libtool'
#brew_install_or_upgrade 'libvo-aacenc'
#brew_install_or_upgrade 'lua'
#
#brew_install_or_upgrade 'makedepend'
#brew_install_or_upgrade 'markdown'
#brew_install_or_upgrade 'mongodb'
#brew_install_or_upgrade 'mpfr'
#brew_install_or_upgrade 'mtr'
#brew_install_or_upgrade 'netcat'
#brew_install_or_upgrade 'netperf'
#brew_install_or_upgrade 'nettle'
#brew_install_or_upgrade 'nginx'
#brew_install_or_upgrade 'ngrep'
#brew_install_or_upgrade 'nload'
#brew_install_or_upgrade 'nmap'
#brew_install_or_upgrade 'ntopng'
#brew_install_or_upgrade 'nuttcp'
#brew_install_or_upgrade 'packer'
#brew_install_or_upgrade 'pandoc'
#brew_install_or_upgrade 'pcre'
#brew_install_or_upgrade 'pixman'
#brew_install_or_upgrade 'pkg-config'
#brew_install_or_upgrade 'psutils'
#brew_install_or_upgrade 'qemu'
#brew_install_or_upgrade 'qt'
#brew_install_or_upgrade 'rbenv'
#brew_install_or_upgrade 'readline'
#brew_install_or_upgrade 'reattach-to-user-namespace'
#brew_install_or_upgrade 'rename'
#brew_install_or_upgrade 'ruby'
#brew_install_or_upgrade 'ruby-build'
#brew_install_or_upgrade 'scapy'
#brew_install_or_upgrade 'sdl2'
#brew_install_or_upgrade 'sdl2_image'
#brew_install_or_upgrade 'sdl2_mixer'
#brew_install_or_upgrade 'sdl2_net'
#brew_install_or_upgrade 'sdl2_ttf'
#brew_install_or_upgrade 'sift'
#brew_install_or_upgrade 'sip'
#brew_install_or_upgrade 'snort'
#brew_install_or_upgrade 'subnetcalc'
#brew_install_or_upgrade 'swig'
#brew_install_or_upgrade 'synscan'
#brew_install_or_upgrade 'tcpreplay'
#brew_install_or_upgrade 'tcptrack'
#brew_install_or_upgrade 'the_silver_searcher'
#brew_install_or_upgrade 'tmux'
#brew_install_or_upgrade 'trash'
#brew_install_or_upgrade 'tree'
#brew_install_or_upgrade 'unar'
#brew_install_or_upgrade 'wakeonlan'
#brew_install_or_upgrade 'webp'
#brew_install_or_upgrade 'wget'
#brew_install_or_upgrade 'wireshark'
#brew_install_or_upgrade 'x264'
#brew_install_or_upgrade 'xvid'
#brew_install_or_upgrade 'xz'
#brew_install_or_upgrade 'z'
#brew_install_or_upgrade 'zeromq'
#brew_install_or_upgrade 'zmap'
#brew_install_or_upgrade 'zopfli'
#
#gem_install_or_update 'tmuxinator'
#brew_install_or_upgrade 'heroku-toolbelt'
#
## Get complete completions
#brew_install_or_upgrade 'apm-bash-completion'
#brew_install_or_upgrade 'aptly-completion'
#brew_install_or_upgrade 'boom-completion'
#brew_install_or_upgrade 'boot2docker-completion'
#brew_install_or_upgrade 'bundler-completion'
#brew_install_or_upgrade 'cargo-completion'
#brew_install_or_upgrade 'composer-completion'
#brew_install_or_upgrade 'ctest-completion'
#brew_install_or_upgrade 'django-completion'
#brew_install_or_upgrade 'docker-completion'
#brew_install_or_upgrade 'docker-machine-completion'
#brew_install_or_upgrade 'fabric-completion'
#brew_install_or_upgrade 'gem-completion'
#brew_install_or_upgrade 'grunt-completion'
#brew_install_or_upgrade 'kitchen-completion'
#brew_install_or_upgrade 'maven-completion'
#brew_install_or_upgrade 'mix-completion'
#brew_install_or_upgrade 'open-completion'
#brew_install_or_upgrade 'packer-completion'
#brew_install_or_upgrade 'pip-completion'
#brew_install_or_upgrade 'rails-completion'
#brew_install_or_upgrade 'rake-completion'
#brew_install_or_upgrade 'ruby-completion'
#brew_install_or_upgrade 'rustc-completion'
#brew_install_or_upgrade 'sonar-completion'
#brew_install_or_upgrade 'spring-completion'
#brew_install_or_upgrade 't-completion'
#brew_install_or_upgrade 'tmuxinator-completion'
#brew_install_or_upgrade 'vagrant-completion'
#brew_install_or_upgrade 'wpcli-completion'
#
## These must be installed manually
#brew install macvim --env-std --with-override-system-vim
#brew install neovim/neovim/neovim
#
## Cask taps needed for Apps and fonts
#brew_tap 'caskroom/versions'
#brew_tap 'caskroom/fonts'
#brew_tap 'caskroom/unofficial'

# Applications
brew_cask_install_or_upgrade 'alfred'
brew_cask_install_or_upgrade 'apache-directory-studio'
brew_cask_install_or_upgrade 'appcleaner'
brew_cask_install_or_upgrade 'arq'
brew_cask_install_or_upgrade 'atom'
brew_cask_install_or_upgrade 'betterzipql'
brew_cask_install_or_upgrade 'cyberduck'
brew_cask_install_or_upgrade 'dash'
brew_cask_install_or_upgrade 'docker'
brew_cask_install_or_upgrade 'dropbox'
brew_cask_install_or_upgrade 'eclipse-java'
brew_cask_install_or_upgrade 'evernote'
brew_cask_install_or_upgrade 'fake'
brew_cask_install_or_upgrade 'fiddler'
brew_cask_install_or_upgrade 'firefox'
brew_cask_install_or_upgrade 'firefoxdeveloperedition'
brew_cask_install_or_upgrade 'flash'
brew_cask_install_or_upgrade 'fluid'
brew_cask_install_or_upgrade 'flux'
brew_cask_install_or_upgrade 'gimp'
brew_cask_install_or_upgrade 'github'
brew_cask_install_or_upgrade 'gns3'
brew_cask_install_or_upgrade 'google-chrome'
brew_cask_install_or_upgrade 'google-chrome-canary'
brew_cask_install_or_upgrade 'google-drive'
brew_cask_install_or_upgrade 'hammerspoon'
brew_cask_install_or_upgrade 'insomniax'
brew_cask_install_or_upgrade 'iterm2'
brew_cask_install_or_upgrade 'java'
brew_cask_install_or_upgrade 'java7'
brew_cask_install_or_upgrade 'keepassx'
brew_cask_install_or_upgrade 'kitematic'
brew_cask_install_or_upgrade 'komodo-edit'
brew_cask_install_or_upgrade 'lastpass'
brew_cask_install_or_upgrade 'lincastor'
brew_cask_install_or_upgrade 'lingon-x'
brew_cask_install_or_upgrade 'livereload'
brew_cask_install_or_upgrade 'near-lock'
brew_cask_install_or_upgrade 'nvalt'
brew_cask_install_or_upgrade 'opera'
brew_cask_install_or_upgrade 'packages'
brew_cask_install_or_upgrade 'pandora'
brew_cask_install_or_upgrade 'postman'
brew_cask_install_or_upgrade 'pycharm'
brew_cask_install_or_upgrade 'qlcolorcode'
brew_cask_install_or_upgrade 'qlimagesize'
brew_cask_install_or_upgrade 'qlmarkdown'
brew_cask_install_or_upgrade 'qlprettypatch'
brew_cask_install_or_upgrade 'qlstephen'
brew_cask_install_or_upgrade 'qq'
brew_cask_install_or_upgrade 'quicklook-csv'
brew_cask_install_or_upgrade 'quicklook-json'
brew_cask_install_or_upgrade 'seil'
brew_cask_install_or_upgrade 'sequel-pro'
brew_cask_install_or_upgrade 'sizeup'
brew_cask_install_or_upgrade 'skype'
brew_cask_install_or_upgrade 'snagit'
brew_cask_install_or_upgrade 'sogouinput'
brew_cask_install_or_upgrade 'spectacle'
brew_cask_install_or_upgrade 'sqlitebrowser'
brew_cask_install_or_upgrade 'sqlitestudio'
brew_cask_install_or_upgrade 'sublime-text-dev'
brew_cask_install_or_upgrade 'sublime-text3'
brew_cask_install_or_upgrade 'subnetcalc'
brew_cask_install_or_upgrade 'suspicious-package'
brew_cask_install_or_upgrade 'synergy'
brew_cask_install_or_upgrade 'tcl'
brew_cask_install_or_upgrade 'toad'
brew_cask_install_or_upgrade 'totalfinder'
brew_cask_install_or_upgrade 'transmission'
brew_cask_install_or_upgrade 'tunnelblick'
brew_cask_install_or_upgrade 'vagrant'
brew_cask_install_or_upgrade 'vagrant-manager'
brew_cask_install_or_upgrade 'virtualbox'
brew_cask_install_or_upgrade 'vlc'
brew_cask_install_or_upgrade 'vmware-fusion'
brew_cask_install_or_upgrade 'webpquicklook'
brew_cask_install_or_upgrade 'wireshark'
brew_cask_install_or_upgrade 'yed'

# Stuff I did not want
#brew_cask_install_or_upgrade 'cheatsheet'
#brew_cask_install_or_upgrade 'airmail-amt'
#brew_cask_install_or_upgrade 'spotify'
#brew_cask_install_or_upgrade 'mailbox'
#brew_cask_install_or_upgrade 'superduper'
#brew_cask_install_or_upgrade 'valentina-studio'
#brew_cask_install_or_upgrade 'shiori'
#brew_cask_install_or_upgrade 'slack'
#brew_cask_install_or_upgrade 'transmit'
#brew_cask_install_or_upgrade 'hazel'

# fonts
brew_cask_install_or_upgrade 'font-source-code-pro'
brew_cask_install_or_upgrade 'font-source-code-pro-for-powerline'
brew_cask_install_or_upgrade 'font-roboto'
brew_cask_install_or_upgrade 'font-fontawesome'   
brew_cask_install_or_upgrade 'font-material-icons'
brew_cask_install_or_upgrade 'font-octicons'      

# Python tools
pip install --upgrade setuptools
pip install --upgrade pip
pip install virtualenv
pip install virtualenvwrapper
pip install powerline-status
pip install nose
pip install pyparsing
pip install python-dateutil
pip install pep8
pip install pyzmq
pip install pygments
pip install jinja2
pip install tornado
pip install pymongo
pip install Cython
pip install blessings
pip install bpython
pip install certifi
pip install decorator
pip install dnet
pip install docker-py
pip install gnureadline
pip install ipaddress
pip install ipython
pip install ipython-genutils
pip install paramiko
pip install pep8
pip install pexpect
pip install powerline-docker
pip install powerline-gitstatus
pip install powerline-mem-segment
pip install powerline-status
pip install prettyprint
pip install pycrypto
pip install pyparsing
pip install python-dateutil
pip install pytz
pip install requests
pip install scapy
pip install simplegeneric
pip install six

# I am not a scientist!
#brew_install_or_upgrade 'homebrew/python/numpy'
#brew_install_or_upgrade 'samueljohn/python/numpy'
#brew_install_or_upgrade 'homebrew/python/scipy'
#brew_install_or_upgrade 'samueljohn/python/scipy'
#brew_install_or_upgrade 'homebrew/python/matplotlib'
#brew_install_or_upgrade 'samueljohn/python/matplotlib'

# Install more recent versions of some OS X tools
# Must install after everything
brew_tap 'homebrew/dupes'
brew_install_or_upgrade 'grep'
brew_install_or_upgrade 'tcl-tk'
brew_install_or_upgrade 'tcpdump'
brew_install_or_upgrade 'gzip'
brew_install_or_upgrade 'unzip'
brew_install_or_upgrade 'lsof'
brew_install_or_upgrade 'openssh'
brew_install_or_upgrade 'rsync'
brew_install_or_upgrade 'screen'
brew_install_or_upgrade 'whois'
brew_install_or_upgrade 'less'
brew_install_or_upgrade 'expect'
brew_install_or_upgrade 'make'
brew_install_or_upgrade 'diffutils'
brew_install_or_upgrade 'diffstat'

# MUST INSTALL JAVA FIRST!!!!!!
#brew_install_or_upgrade 'scala'
#brew_install_or_upgrade 'sbt'
#echo 'SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:PermSize=256M -XX:MaxPermSize=512M -Xmx2G"' >> ~/.sbtconfig

pip install ipython

# Apps that affect script so must be last!!
brew_install_or_upgrade 'ack'
brew_install_or_upgrade 'awk'

brew linkapps
brew update
brew upgrade
brew cask update
brew cleanup
brew cask cleanup
brew doctor
brew cask doctor
brew cask audit

