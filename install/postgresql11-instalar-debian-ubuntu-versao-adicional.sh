#!/bin/bash
#
# Instalar o PostgreSQL código fonte no Debian Gnu/Linux 11
# ao lado de uma instalação existente.
# 
#
# Autor: Ricardo Cassiano


echo '
Script para compilar e instalar o PostgreSQL 11 no Debian Gnu/Linux 11.

Código fonte disponível em https://www.postgresql.org/ftp/source/

Esse script é adaptado da documentação oficial disponível em 

https://www.postgresql.org/docs/11/installation.html

Você pode modificá-lo de acordo com as duas necessidades.

'

sleep 2

VERSAO=11.17

sudo apt-get -y install  bison flex llvm clang zlib1g-dev \
lib{ssl,systemd,readline,xslt1,xml2}-dev m4 make autoconf \
pkgconf flex gcc make guile-2.2-dev patch automake  python3-dev


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

# Deixar o serviço desabilitado por padrão

sudo systemctl disable postgresql11.service

sudo systemctl daemon-reload


echo "Instalação completada. Agora é necessário reiniciar o computador!
Por padrão, o serviço do PostgreSQL $VERSAO está desabilidato.
Você pode habilitar executando:
sudo systemctl enable postgresql11.service"
