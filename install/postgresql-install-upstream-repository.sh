#!/bin/bash
#
# Configura o repositório e instala o PostgreSQL e PgAdmin (desktop) no Debian / Ubuntu.
# 
#
# Autor: Ricardo Cassiano
#
#
# TODO
# Validar versão digita pelo usuário


echo "
 
 Configura o repositório e instala o PostgreSQL e PgAdmin (desktop) no Debian 12+ / Ubuntu 22.04+ / Linux Mint 21+.


https://www.postgresql.org/download/linux/debian/

PgAdmin

https://www.pgadmin.org/download/pgadmin-4-apt/

"

sleep 1

read -r -p "Digite a versão que você quer instalar (ex: 15, 16)": VERSAO

#  Instalar os pacotes necessários para configurar os repositótios

sudo apt-get -y install curl wget lsb-release


# Verificar se a distruição é Linux Mint para poder usar o codinome do Ubuntu

if [ "$(grep -E '^ID=' /etc/os-release)" = "ID=linuxmint" ]; then
	distro=$(grep -Po '(?<=UBUNTU_CODENAME=)\w+' /etc/os-release)	
else
    distro=$(lsb_release -cs)   
fi

# Adicionar repositórios


sudo tee -a /etc/apt/sources.list.d/pgsql.list>>/dev/null<<EOF

deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt "${distro}"-pgdg main

deb [arch=amd64] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/"${distro}" pgadmin4 main

EOF


wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add


# Atualiza repositórios e instala os pacotes

sudo apt-get update

sudo apt-get -y install pgadmin4-desktop postgresql-"${VERSAO}" postgresql-client-"${VERSAO}"

sudo systemctl disable postgresql

sudo systemctl stop postgresql

echo "Instalação finalizada!!"
