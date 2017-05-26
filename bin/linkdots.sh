#!/usr/bin/env bash

# List of my dotfiles for MAC OS
my_dotfiles="admin-openrc.sh agignore aliases apmrc bashrc demo-openrc.sh gemrc gitconfig gitignore gitignore_global gitmessage hgignore_global ideavimrc LESS_TERMCAP macos mongo_hacker.js mongorc.js myshutils.sh netrc powerlevel9k psqlrc psqlrc.local rspec rvmrc sbtconfig tmux.conf vimrc vimrc.bundles zshenv zshrc iterm2_shell_integration.zsh iterm2"

# List of my dotfiles for Linux
mylinux_dotfiles="admin-openrc.sh agignore aliases apmrc bashrc demo-openrc.sh gemrc gitconfig gitignore gitignore_global gitmessage hgignore_global LESS_TERMCAP mongo_hacker.js mongorc.js myshutils.sh netrc powerlevel9k psqlrc psqlrc.local rspec rvmrc sbtconfig tmux.conf vimrc vimrc.bundles zshenv zshrc"


# get and store OS type
ostype=$(uname -s)

echo "You are on a $ostype machine."
if [[ $ostype == "Darwin" ]]; then
    for i in $my_dotfiles; do
        if ! [[ -f ~/.$i ]]; then
            ln -s ~/.dotfiles/$i ~/.$i
        fi
        sudo cp ~/.dotfiles/hosts /private/etc/hosts
    done
    exit 0
elif [[ $ostype == "Linux" ]]; then
    for i in $mylinux_dotfiles; do
        if ! [[ -f ~/.$i ]]; then
            if [[ -f ~/.dotfiles/linux/$i ]]; then
                ln -s ~/.dotfiles/linux/$i ~/.$i
            else ln -s ~/.dotfiles/$i ~/.$i
            fi
        fi
        sudo cp ~/.dotfiles/hosts /etc/hosts
    done
    exit 0
elif [[ $ostype == "FreeBSD" ]]; then
    for i in $mylinux_dotfiles; do
        if ! [[ -f ~/.$i ]]; then
            if [[ -f ~/.dotfiles/linux/$i ]]; then
                ln -s ~/.dotfiles/linux/$i ~/.$i
            else ln -s ~/.dotfiles/$i ~/.$i
            fi
        fi
        sudo cp ~/.dotfiles/hosts /etc/hosts
    done
    exit 0
else echo "Cannot run on this system"
exit 0
fi    

