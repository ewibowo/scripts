#!/bin/sh

tar -xvf jdk-8*
sudo mkdir /usr/lib/jvm
sudo mv ./jdk1.8* /usr/lib/jvm/jdk1.8.0_77
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_77/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0_77/bin/javac" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.8.0_77/bin/javaws" 1
sudo chmod a+x /usr/bin/java
sudo chmod a+x /usr/bin/javac
sudo chmod a+x /usr/bin/javaws
sudo chown -R root:root /usr/lib/jvm/jdk1.8.0_77
sudo update-alternatives --config java
sudo update-alternatives --config javac
sudo update-alternatives --config javaws
