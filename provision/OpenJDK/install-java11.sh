#!/bin/bash

#
# install-java11.sh
# Installs Java11 on linux systems using yum and rpm.
#
# History
#   2020/06/17  mlohn     Created.
#
# Usage
#
#    install-java11.sh
#

echo "Install OpenJDK 11..."
sudo yum -y -t update
sudo yum -y -t install java-11-openjdk-devel
