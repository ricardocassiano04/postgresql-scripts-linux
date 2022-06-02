# Compile PostgreSQL from source on Debian Gnu/Linux 11
#
# Author: Ricardo Cassiano
# E-mail: rc.cassiano04@outlook.com
# Github: https://github.com/ricardocassiano04/

echo '
Script to download and install PostgreSQL 11 on Debian Gnu/Linux 11

alongside the default instalation from sources 

at https://www.postgresql.org/

You can see the oficial documentation about installation from sources 

here: https://www.postgresql.org/docs/11/installation.html

You can adjust other configurations according your own needs.

'


# Install dependencies without ask to the user.

sudo apt-get -y install  bison flex llvm clang zlib1g-dev \
lib{ssl,systemd,readline,xslt1,xml2}-dev m4 make autoconf \
pkgconf flex gcc make guile-2.2-dev patch automake

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

# Change the owner of instalation folder to postgres system user.

sudo chown -R postgres:postgres /usr/local/pgsql


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


echo 'Instalation finished. 

You need to run 

/usr/local/pgsql/11/bin/initdb -D /usr/local/pgsql/11/data

to initialize database cluster.'





