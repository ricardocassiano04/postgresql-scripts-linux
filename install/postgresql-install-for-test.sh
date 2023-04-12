#!/bin/bash
#
# This bash script compiles PostgreSQL from sources on Debian (11+) / Ubuntu (20.04+).
#
# Only for test
#
# Author: Ricardo Cassiano


echo "
Script to compile PostgreSQL on Debian (11+) / Ubuntu (20.04+).

This script is adapted from official documentation at 

https://www.postgresql.org/docs/current/installation.html

"

sleep 2


read -r -p "Type the version you want (eg: 11.19, 15.2)": VERSION

BUILD_FOLDER=$HOME/builds

mkdir -p $BUILD_FOLDER

cd $BUILD_FOLDER/



# Install required packages

sudo apt-get -y install  bison flex llvm clang zlib1g-dev \
lib{ssl,systemd,readline,xslt1,xml2}-dev m4 make autoconf \
pkgconf flex gcc make guile-2.2-dev patch automake  python3-dev

# Download sources and extract the tar.gz file

wget -c https://ftp.postgresql.org/pub/source/v"$VERSION"/postgresql-"$VERSION".tar.gz

tar -xf postgresql-"$VERSION".tar.gz

cd postgresql-"$VERSION" || return

# Run the configuration and make

CXX=/usr/bin/g++ PYTHON=python3 ./configure \
--prefix=/opt/pgsql/"$VERSION" \
--with-pgport=5435 \
--with-python \
--with-openssl \
--with-systemd \
--with-libxml \
--with-libxslt

make world

sudo make install-world

cd src/interfaces/libpq || return

make

sudo make install

# Create user postgres if not exists 

if [ "$(grep -c '^postgres:' /etc/passwd)" = 0 ]; then
	sudo useradd --system --shell /usr/bin/bash  --no-create-home postgres
else
    echo "postgres user already created"	
fi

# Make postgres user the owner of /opt/pgsql folder

sudo chown -R postgres:postgres /opt/pgsql

echo "Compilation finished!!" 
