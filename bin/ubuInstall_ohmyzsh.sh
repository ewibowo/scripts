#!/bin/sh

# Get the apps
sudo apt-get install vim curl zsh git-core -y
# Get oh-my-zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh
# Switch shell
sudo chsh -s $(which zsh) $(whoami)
