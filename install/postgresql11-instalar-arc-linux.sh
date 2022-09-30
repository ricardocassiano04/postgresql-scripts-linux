#!/bin/bash
#
# Install PostgreSQL from source on Arch Linux e derivados.
#
# Author: Ricardo Cassiano


echo '
Script para compilar e instalar o PostgreSQL 11 no Arch Linux e derivados.

Código fonte disponível em https://www.postgresql.org/ftp/source/

Esse script é adaptado da documentação oficial disponível em 

https://www.postgresql.org/docs/11/installation.html

Você pode modificá-lo de acordo com as duas necessidades.

'

sleep 2

VERSAO=11.17


sudo pacman -S --needed bison flex libxml2 llvm clang \
openssl zlib libxslt m4 make autoconf \
pkgconf flex gc gcc make guile patch automake


wget -c https://ftp.postgresql.org/pub/source/v"$VERSAO"/postgresql-"$VERSAO".tar.gz

tar -xf postgresql-"$VERSAO".tar.gz

cd postgresql-"$VERSAO" || return

CXX=/usr/bin/g++ PYTHON=python3 ./configure \
--prefix=/usr/local/pgsql/11 \
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

sudo useradd --system --shell /usr/bin/bash  --no-create-home postgres

sudo chown -R postgres:postgres /usr/local/pgsql

sudo tee -a /etc/profile.d/pgsql.sh>>/dev/null<<EOF
LD_LIBRARY_PATH=/usr/local/pgsql/11/lib
export LD_LIBRARY_PATH

PATH=/usr/local/pgsql/11/bin:$PATH
export PATH

MANPATH=/usr/local/pgsql/11/share/man:$MANPATH
export MANPATH
EOF

sudo chmod +x /etc/profile.d/pgsql.sh

sudo /sbin/ldconfig /usr/local/pgsql/11/lib

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

sudo systemctl disable postgresql11.service

sudo systemctl daemon-reload


echo "Instalação completada. Agora é necessário reiniciar o computador!
Por padrão, o serviço do PostgreSQL $VERSAO está desabilidato.
Você pode habilitar executando:
sudo systemctl enable postgresql11.service"