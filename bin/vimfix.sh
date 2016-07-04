#!/usr/bin/env sh

echo "Removing python links"
brew unlink python
echo "Removing macvim links"
brew unlink macvim
echo "Uninstalling macvim"
brew remove macvim
echo "Re-installing macvim"
brew install macvim --env-std --with-override-system-vim
echo "Linking macvim"
brew link macvim
echo "Linking python"
brew link python
echo "Done! Now try vim!"
