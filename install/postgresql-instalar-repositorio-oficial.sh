#!/bin/bash
#
# Instala o PostgreSQL e o PgAdmin (desktop) no Debian/Ubuntu
# a partir do repositório oficial.
#
# Autor: Ricardo Cassiano
#

echo "
Instala o PostgreSQL e o PgAdmin no Debian/Ubuntu
a partir do repositório oficial.

PostgreSQL
Baseado em https://www.postgresql.org/download/linux/debian/ (para Debian)
e em https://www.postgresql.org/download/linux/ubuntu/ (para Ubuntu)

PgAdmin

https://www.pgadmin.org/download/pgadmin-4-apt/

Se você está usando o Linux Mint, substitua o $(lsb_release -cs) pelo nome 
da versão do Ubuntu. 
Para descobrir esse nome, execute cat /etc/os-release no
terminal e procure pela linha UBUNTU_CODENAME.

Você pode modificá-lo de acordo com as duas necessidades.

"

sleep 2

sudo apt-get -y install curl wget

sudo sh -c 'echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add


sudo apt-get update

sudo apt-get -y install pgadmin4-desktop postgresql postgresql-doc postgresql-contrib


sudo systemctl disable postgresql


sudo systemctl stop postgresql

echo "Instalação terminada!"
