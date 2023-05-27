#!/bin/bash
#
# This bash script compiles PostgreSQL from sources on Debian (11+) / Ubuntu (20.04+).
#
# Author: Ricardo Cassiano


echo "
Script to compile PostgreSQL on Debian (11+) / Ubuntu (20.04+).

This script is adapted from official documentation at 

https://www.postgresql.org/docs/current/installation.html

"

sleep 1


read -r -p "Type the version you want (eg: 12.15, 15.3)": VERSION


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
--prefix=/usr/local/pgsql/"$VERSION" \
--with-pgport=5433 \
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

# Make postgres user the owner of /usr/local/pgsql folder

sudo chown -R postgres:postgres /usr/local/pgsql

# Verifiy if already exists a postgresql installation. 
# If not, configure binaries, manual and library path.

command -v psql >/dev/null 2>&1 || \
{ sudo tee -a /etc/profile.d/pgsql.sh>>/dev/null<<EOF
LD_LIBRARY_PATH=/usr/local/pgsql/"$VERSION"/lib
export LD_LIBRARY_PATH

PATH=/usr/local/pgsql/"$VERSION"/bin:$PATH
export PATH

MANPATH=/usr/local/pgsql/"$VERSION"/share/man:$MANPATH
export MANPATH
EOF
sudo /sbin/ldconfig /usr/local/pgsql/"$VERSION"/lib
sudo chmod +x /etc/profile.d/pgsql.sh
exit 1; }

# Remove postgresql systemd service if it exists and create a new one.

sudo rm  -f /etc/systemd/system/postgresql"$VERSION".service

sudo tee -a /etc/systemd/system/postgresql"$VERSION".service>>/dev/null<<EOF

[Unit]
Description=PostgreSQL "$VERSION" database server
Documentation=man:postgres(1)

[Service]
Type=notify
User=postgres
ExecStart=/usr/local/pgsql/"$VERSION"/bin/postgres -D /usr/local/pgsql/"$VERSION"/data
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
KillSignal=SIGINT
TimeoutSec=0

[Install]
WantedBy=multi-user.target
EOF

# Disable postgresql systemd service.

sudo systemctl disable postgresql"$VERSION".service

sudo systemctl daemon-reload


echo "Compilation finished. 

By default, the postgresql$VERSION service is disabled.

You can enable it by running: 

sudo systemctl enable postgresql$VERSION.service"
