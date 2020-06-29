#!/bin/bash

#
# provision.sh
# Prepares the Linux OS and controls the VM provision process.
#
# History
#   2020/06/22  mlohn     Created.
#
# Usage
#
#    provision.sh
#

if ! [ $(id -u) = 0 ]; then
   echo "This script must be run as root."
   exit 1
fi

cd /vagrant/provision/flyway && source ./install-flyway.sh
cd /vagrant/provision/OracleXE && source ./install-oracle-xe.sh

if [ `id -u oracle 2>/dev/null || echo -1` -ge 0 ];
   then
      ORACLE_GROUP=oinstall
      ORACLE_USER=oracle
   else
      ORACLE_GROUP=vagrant
      ORACLE_USER=vagrant
fi
echo $ORACLE_USER
cd /vagrant/provision/db-sample-schemas-18c && su $ORACLE_USER -c 'source ./install-sample-schemas.sh'
