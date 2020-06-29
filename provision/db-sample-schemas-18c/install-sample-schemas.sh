#!/bin/bash

#
# install-sample-schemas.sh
# Installs sample database schemas in Oracle XE. It assumes that Oracle XE
# is already installed.
#
# The script must be run as ORACLE user connected to the OS.
#
# History
#   2020/06/22  mlohn     Created.
#
# Usage
#
#    install-sample-schemas.sh
#

export PATH=$PATH:$ORACLE_HOME/bin
export ORAENV_ASK=NO

if ! [ -d "$ORACLE_BASE/db-sample-schemas-master" ]
      then
         echo "Download Oracle Sample Schematas from github..."
         wget https://github.com/oracle/db-sample-schemas/archive/master.zip -O $ORACLE_BASE/master.zip
         unzip $ORACLE_BASE/master.zip -d $ORACLE_BASE
         cd "$ORACLE_BASE/db-sample-schemas-master" && perl -p -i.bak -e 's#__SUB__CWD__#'$(pwd)'#g' *.sql */*.sql */*.dat
         rm $ORACLE_BASE/master.zip

         echo "Setup environment..."
         source $ORACLE_HOME/bin/oraenv

         echo "Install sample schemas..."
         $ORACLE_HOME/bin/sqlplus system/$ORACLE_PASSWORD@localhost:1521/XEPDB1 @$ORACLE_BASE/db-sample-schemas-master/mksample $ORACLE_PASSWORD $ORACLE_PASSWORD $ORACLE_PASSWORD $ORACLE_PASSWORD $ORACLE_PASSWORD $ORACLE_PASSWORD $ORACLE_PASSWORD $ORACLE_PASSWORD users temp /tmp/install-sample-schemas.log localhost:1521/XEPDB1
fi
