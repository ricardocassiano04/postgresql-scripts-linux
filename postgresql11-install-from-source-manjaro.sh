# Compile PostgreSQL from source on Linux Manjaro
#
# Author: Ricardo Cassiano
# E-mail: rc.cassiano04@outlook.com
# Github: https://github.com/ricardocassiano04/

echo 'Script to download and install PostgreSQL 11 on Linux Manjaro

from sources at https://www.postgresql.org/

You can see the oficial documentation about installation from sources here:

https://www.postgresql.org/docs/11/installation.html

You can adjust other configurations according your own needs.

'


# Install dependencies without ask to the user.

sudo pacman -S --needed --noconfirm bison flex libxml2 llvm clang openssl zlib libxslt m4 make autoconf pkgconf flex gc gcc make guile patch automake

# Download and extract the source, then enter source folder and run configure script.

wget -c https://ftp.postgresql.org/pub/source/v11.16/postgresql-11.16.tar.gz

tar -xf postgresql-11.16.tar.gz

cd postgresql-11.16


CXX=/usr/bin/g++ PYTHON=python3 ./configure \
--prefix=/usr/local/pgsql/11 \
--with-pgport=5433 \
--with-python \
--with-openssl \
--with-systemd \
--with-libxml \
--with-libxslt

# Then run make in main folder (this can take several minutes).

make world

sudo make install-world

# Now go to folder "src/interfaces/libpq" and run make too.

cd src/interfaces/libpq

make

sudo make install

# Create postgres user (note: by default useradd creates a group with same user name)

sudo useradd --system --shell /usr/bin/bash  --no-create-home postgres

sudo chown -R postgres:postgres /usr/local/pgsql


# Configure PATH (I prefer to create a separated profile file in /etc/profile.d folder).

sudo tee -a /etc/profile.d/pgsql.sh>>/dev/null<<EOF
LD_LIBRARY_PATH=/usr/local/pgsql/11/lib
export LD_LIBRARY_PATH

PATH=/usr/local/pgsql/11/bin:$PATH
export PATH

MANPATH=/usr/local/pgsql/11/share/man:$MANPATH
export MANPATH
EOF

# Adjust execution permissions

sudo chmod +x /etc/profile.d/pgsql.sh

# Config libraries

sudo /sbin/ldconfig /usr/local/pgsql/11/lib


# Create systemd service

sudo tee -a /etc/systemd/system/postgresql11.service>>/dev/null<<EOF

[Unit]
Description=PostgreSQL 11 database server
Documentation=man:postgres(1)

[Service]
Type=notify
User=postgres
ExecStart=/usr/local/pgsql/11/bin/postgres -D /usr/local/pgsql/11/data
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
KillSignal=SIGINT
TimeoutSec=0

[Install]
WantedBy=multi-user.target
EOF

# Disable the service. Could be enable with

sudo systemctl disable postgresql11.service

sudo systemctl daemon-reload


echo 'Instalation finished. You need to restart your system to apply some configurations!'





