#!/bin/bash
#
# This bash script compiles PostgreSQL from sources on Arch Linux (and derivatives).
#
# Only for test
#
# Author: Ricardo Cassiano


echo "
Script to compile PostgreSQL on Arch Linux (and derivatives).

This script is adapted from official documentation at 

https://www.postgresql.org/docs/current/installation.html

"

sleep 1


read -r -p "Type the version you want (eg: 15.4, 16.0)": VERSION

read -r -p "Type postgresql install folder (eg: /opt/pgsql)": INSTALL_FOLDER

MAJOR_VERSION=$(cut -c 1-2 <<< "$VERSION")

sudo mkdir -p "${INSTALL_FOLDER}" 

BUILD_FOLDER="$HOME"/builds

mkdir -p "${BUILD_FOLDER}"



cd "${BUILD_FOLDER}"/ || return

# Install required packages

sudo pacman -S --needed bison flex libxml2 llvm clang \
openssl zlib libxslt m4 make autoconf \
pkgconf flex gc gcc make guile patch automake

# Download sources and extract the tar.gz file

wget -c https://ftp.postgresql.org/pub/source/v"$VERSION"/postgresql-"$VERSION".tar.gz

tar -xf postgresql-"$VERSION".tar.gz

cd postgresql-"$VERSION" || return

# Run the configuration and make

CXX=/usr/bin/g++ PYTHON=python3 ./configure \
--prefix="${INSTALL_FOLDER}"/"$MAJOR_VERSION" \
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

# Make postgres user the owner of "${INSTALL_FOLDER}" folder

sudo chown -R postgres:postgres "${INSTALL_FOLDER}"

echo "Instalation finished!!" 
