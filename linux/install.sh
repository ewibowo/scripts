#!/bin/sh

sudo -i

# Remove all old Docker installs
sudo apt-get remove docker docker-engine docker.io

# Add Ansible PPA
sudo apt-add-repository ppa:ansible/ansible

# SET UP THE REPOSITORY
# Update the apt package index:
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS:
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify that the key fingerprint is 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88.
sudo apt-key fingerprint 0EBFCD88

# Use the following command to set up the stable repository.
# You always need the stable repository, even if you want to install builds from the edge or testing repositories as well.
# To add the edge or testing repository, add the word edge or testing (or both) after the word stable in the commands below.
# Note: The lsb_release -cs sub-command below returns the name of your Ubuntu distribution, such as xenial.
# Sometimes, in a distribution like Linux Mint, you might have to change $(lsb_release -cs) to your parent Ubuntu distribution.
# For example: If you are using Linux Mint Rafaela, you could use trusty.

# amd64:
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

## armhf:
#sudo add-apt-repository \
#   "deb [arch=armhf] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) \
#   stable"
#
## s390x:
#sudo add-apt-repository \
#   "deb [arch=s390x] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) \
#   stable"

# Note: Starting with Docker 17.06, stable releases are also pushed to the edge and testing repositories.
# Learn about stable and edge channels.
# INSTALL DOCKER CE
# Update the apt package index.
sudo apt-get update

# Install the latest version of Docker CE, or go to the next step to install a specific version. Any existing installation of Docker is replaced.
sudo apt-get install -y docker-ce ansible

# Warning: If you have multiple Docker repositories enabled, installing or updating without specifying a version in the apt-get install or 
# apt-get update command will always install the highest possible version, which may not be appropriate for your stability needs.
# On production systems, you should install a specific version of Docker CE instead of always using the latest.
# List the available versions.
#apt-cache madison docker-ce

# The contents of the list depend upon which repositories are enabled, and will be specific to your version of Ubuntu (indicated by the xenial suffix on the version, in this example).
# Choose a specific version to install.
# The second column is the version string.
# The third column is the repository name, which indicates which repository the package is from and by extension its stability level.
# To install a specific version, append the version string to the package name and separate them by an equals sign (=):
#sudo apt-get install docker-ce=<VERSION>

sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

# Specify DNS servers for Docker
# The default location of the configuration file is /etc/docker/daemon.json. You can change the location of the configuration file using the --config-file daemon flag. The documentation below assumes the configuration file is located at /etc/docker/daemon.json.

# Create or edit the Docker daemon configuration file, which defaults to /etc/docker/daemon.json file, which controls the Docker daemon configuration.
#sudo nano /etc/docker/daemon.json

# Add a dns key with one or more IP addresses as values. If the file has existing contents, you only need to add or edit the dns line.
#{
#	"dns": ["8.8.8.8", "8.8.4.4"]
#}

# If your internal DNS server cannot resolve public IP addresses, include at least one DNS server which can, so that you can connect to Docker Hub and so that your containers can resolve internet domain names.
# Save and close the file.

# Restart the Docker daemon.
#sudo service docker restart

curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose
autoload -Uz compinit && compinit -i
exec $SHELL -l
