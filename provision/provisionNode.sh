#!/bin/bash

#
# provision.sh
# Prepares the Linux OS and controls the VM provision process.
#
# History
#   2020/06/17  mlohn     Created.
#
# Usage
#
#    provision.sh
#

if ! [ $(id -u) = 0 ]; then
   echo "This script must be run as root."
   exit 1
fi

echo "Installing openssl..."
sudo yum -y -t install openssl > /dev/null

cd /vagrant/provision/OpenJDK && source ./install-java11.sh
