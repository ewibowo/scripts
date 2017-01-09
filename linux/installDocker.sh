#!/bin/sh

set e

sudo -v

sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv \
               --keyserver hkp://ha.pool.sks-keyservers.net:80 \
               --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Precise='Precise_12.04'
# Trusty='Trusty_14.04'
# Wily='Wily_15.10'
# Xenial='Xenial_16.04'

Precise="deb https://apt.dockerproject.org/repo ubuntu-precise main"
Trusty="deb https://apt.dockerproject.org/repo ubuntu-trusty main"
Wily="deb https://apt.dockerproject.org/repo ubuntu-wily main"
Xenial="deb https://apt.dockerproject.org/repo ubuntu-xenial main"

echo "$(Xenial)" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update
echo "Verify APT is using the correct repos"
apt-cache policy docker-engine
echo "Install the linux-image-extra-* packages"
sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
echo "Installing docker"
sudo apt-get update
sudo apt-get install docker-engine
echo "Starting docker"
sudo service docker start
echo "Use docker without sudo perms"
sudo groupadd docker
sudo usermod -aG docker $USER
echo "Enable autostart docker service"
sudo systemctl enable docker
echo "Edit this file for docker DNS"
sudo vim /etc/docker/daemon.json
{
    "dns": ["8.8.8.8", "8.8.4.4"]
}
echo "Restart docker"
sudo service docker restart
