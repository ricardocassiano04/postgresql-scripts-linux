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
 Install PostgreSQL and PgAdmin (desktop) on Debian (12+) / Ubuntu (22.04+) / Linux Mint 21+
 from upstream repository.


https://www.postgresql.org/download/linux/debian/

PgAdmin

https://www.pgadmin.org/download/pgadmin-4-apt/

If you are using Linux Mint, replace $(lsb_release -cs) with
UBUNTU_CODENAME located at /etc/os-release

"

sleep 1

read -r -p "Type the major version you want (eg: 15, 16)": VERSION

# Install required packages

sudo apt-get -y install curl wget lsb-release


# Get distro name (check if it's Linux Mint to put Ubuntu codename)

if [ "$(grep -E '^ID=' /etc/os-release)" = "ID=linuxmint" ]; then
	distro=$(grep -Po '(?<=UBUNTU_CODENAME=)\w+' /etc/os-release)	
else
    distro=$(lsb_release -cs)   
fi

# Configure repositories


sudo tee -a /etc/apt/sources.list.d/pgsql.list>>/dev/null<<EOF

deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt "${distro}"-pgdg main

deb [arch=amd64] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/"${distro}" pgadmin4 main

EOF


wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add


# Update repositories list and installs postgresql
sudo apt-get update

sudo apt-get -y install pgadmin4-desktop postgresql-"${VERSION}" postgresql-client-"${VERSION}"

sudo systemctl disable postgresql

sudo systemctl stop postgresql

echo "Installation finished!!"
