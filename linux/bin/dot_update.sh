#!/bin/sh

rm -rf $HOME/.bin
rm -rf $HOME/.config
rm -rf $HOME/.dotfiles
rm -rf $HOME/scripts
rm -rf $HOME/.tmux
rm -rf $HOME/.tmuxinator
rm -rf $HOME/.vim
rm -rf $HOME/.zplug
rm -rf $HOME/.zsh
rm -rf $HOME/.agignore
rm -rf $HOME/.aliases
rm -rf $HOME/.gitconfig
rm -rf $HOME/.gitignore
rm -rf $HOME/.gitignore_global
rm -rf $HOME/.gitmessage
rm -rf $HOME/.tmux.conf
rm -rf $HOME/.vimrc
rm -rf $HOME/.vimrc.bundles
rm -rf $HOME/.zshenv
rm -rf $HOME/.zshrc

git clone https://github.com/rlaneyjr/config.git $HOME/.config
git clone https://github.com/rlaneyjr/dotfiles.git $HOME/.dotfiles
git clone https://github.com/rlaneyjr/scripts.git $HOME/scripts
git clone https://github.com/rlaneyjr/tmux.git $HOME/.tmux
git clone https://github.com/rlaneyjr/tmuxinator.git $HOME/.tmuxinator
git clone https://github.com/rlaneyjr/vim.git $HOME/.vim
git clone https://github.com/rlaneyjr/zplug.git $HOME/.zplug
git clone https://github.com/rlaneyjr/zsh.git $HOME/.zsh

ln -s $HOME/.dotfiles/agignore $HOME/.agignore
ln -s $HOME/.dotfiles/aliases $HOME/.aliases
ln -s $HOME/.dotfiles/gitconfig $HOME/.gitconfig
ln -s $HOME/.dotfiles/gitignore $HOME/.gitignore
ln -s $HOME/.dotfiles/gitignore_global $HOME/.gitignore_global
ln -s $HOME/.dotfiles/gitmessage $HOME/.gitmessage
ln -s $HOME/.dotfiles/tmux.conf $HOME/.tmux.conf
ln -s $HOME/.dotfiles/vimrc $HOME/.vimrc
ln -s $HOME/.dotfiles/vimrc.bundles $HOME/.vimrc.bundles
ln -s $HOME/.dotfiles/zshenv $HOME/.zshenv
ln -s $HOME/.dotfiles/zshrc $HOME/.zshrc
