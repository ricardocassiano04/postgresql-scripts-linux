#!/bin/bash
#
# Configura o repositório e instala o PostgreSQL e PgAdmin (desktop) no Debian.
# 
#
# Autor: Ricardo Cassiano
#
#
# TODO
# Validar versão digitada pelo usuário


echo "
 
 Configura o repositório e instala o PostgreSQL e PgAdmin (desktop) no Debian 12+.


https://www.postgresql.org/download/linux/debian/

PgAdmin

https://www.pgadmin.org/download/pgadmin-4-apt/

"

sleep 1

read -r -p "Digite a versão que você quer instalar (ex: 15, 16, 17)": VERSAO

#  Instalar os pacotes necessários para configurar os repositótios

sudo apt-get -y install curl wget lsb-release ca-certificates



# Verificar se a distruição é Linux Mint para poder usar o codinome do Debian

if [ "$(grep -E '^ID=' /etc/os-release)" = "ID=linuxmint" ]; then
	distro=$(grep -Po '(?<=DEBIAN_CODENAME=)\w+' /etc/os-release)	
else
    distro=$(grep -Po '(?<=VERSION_CODENAME=)\w+' /etc/os-release)
fi


# Importa a chave do repositório 

sudo install -d /usr/share/postgresql-common/pgdg

sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc

curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg


# Adicionar repositórios

sudo tee -a /etc/apt/sources.list.d/pgsql.list>>/dev/null<<EOF

deb [arch=amd64 signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] http://apt.postgresql.org/pub/repos/apt "${distro}"-pgdg main

deb [arch=amd64 signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/"${distro}" pgadmin4 main

EOF


# Atualiza repositórios e instala os pacotes

sudo apt-get update

sudo apt-get -y install pgadmin4-desktop postgresql-"${VERSAO}" postgresql-client-"${VERSAO} \
postgresql-doc-"${VERSAO} postgresql-plpython3-"${VERSAO}" \
postgresql-server-dev-"${VERSAO}" pg-activity


# Desabilitabdo e parando o serviço do postgresql

sudo systemctl disable postgresql

sudo systemctl stop postgresql

echo "Instalação finalizada!!"
