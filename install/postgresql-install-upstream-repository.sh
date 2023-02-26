#!/bin/bash
#
# Install PostgreSQL and PgAdmin (desktop) on Debian / Ubuntu
# from upstream repository.
#
# 
#
# Author: Ricardo Cassiano
#
#
#

echo "
 Install PostgreSQL and PgAdmin (desktop) on Debian / Ubuntu
 from upstream repository.


https://www.postgresql.org/download/linux/debian/

PgAdmin

https://www.pgadmin.org/download/pgadmin-4-apt/

If you are using Linux Mint, replace $(lsb_release -cs) with
UBUNTU_CODENAME located at /etc/os-release

"

sleep 1

# Install required packages
sudo apt-get -y install curl wget

# Create the sourcelist and import the keys
#
# TODO:
# Detect if the OS is a Linux Mint if so, change release name to Ubuntu.

sudo sh -c 'echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add


# Update repositories list and installs postgresql
sudo apt-get update

sudo apt-get -y install pgadmin4-desktop postgresql postgresql-doc postgresql-contrib

sudo systemctl disable postgresql

sudo systemctl stop postgresql

echo "Installation finished!!"
