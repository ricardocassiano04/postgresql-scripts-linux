#!/bin/bash
#
# Configura o repositório e instala o PostgreSQL no Debian 11+,  Ubuntu / Linux Mint.
# 
#
# Autor: Ricardo Cassiano
#
#
# TODO
# Validar versão digitada pelo usuário


echo "
 
Verificando se sua ditribuição é compatível com o script...

"

sleep 3


# Verificar a distibuição

source /etc/os-release

if [[ "$ID" == "linuxmint" || "$ID" == "ubuntu" ]]; then
   distro="$UBUNTU_CODENAME"
   echo "Sua distro $PRETTY_NAME é suportada. Iniciando a instalação..."
   
elif [[ "$ID" == "ubuntu" ]]; then
   distro="$VERSION_CODENAME"
   echo "Sua distro $PRETTY_NAME é suportada. Iniciando a instalação..."
   
elif [[ "$ID" == "debian"  ]]; then
	versao=${VERSION_ID%%.*}
	
	if ((  versao < 12 )); then
		echo "Sua distro $PRETTY_NAME não é suportada por este script. Saindo..."
		exit 0
	elif (( versao > 11 )); then
		distro="$VERSION_CODENAME"
		echo "Sua distro $PRETTY_NAME é suportada. Iniciando a instalação..."
	fi
fi



echo "
 
 Configura o repositório e instala o PostgreSQL no Debian 11+,  Ubuntu / Linux Mint.


https://www.postgresql.org/download/linux/debian/

"


sleep 1

read -r -p "Digite a versão que você quer instalar (ex: 15, 16, 17, 18)": VERSAO

#  Instalar os pacotes necessários para configurar os repositótios

sudo apt-get -y install curl wget lsb-release ca-certificates

# Importa a chave do repositório 

sudo apt install curl ca-certificates

sudo install -d /usr/share/postgresql-common/pgdg

sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc



# Adicionar repositórios

sudo tee -a /etc/apt/sources.list.d/pgsql.list>>/dev/null<<EOF

deb [arch=amd64 signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] http://apt.postgresql.org/pub/repos/apt "${distro}"-pgdg main


EOF


# Atualiza repositórios e instala os pacotes

sudo apt-get update

sudo apt-get install postgresql-client-"${VERSAO}"

sudo apt-get -y install postgresql-"${VERSAO}" \
postgresql-doc-"${VERSAO}" postgresql-plpython3-"${VERSAO}" \
postgresql-server-dev-"${VERSAO}" pg-activity \
postgresql-"${VERSAO}"-repack 


# Desabilitabdo e parando o serviço do postgresql

sudo systemctl disable postgresql

echo "Instalação finalizada!!"
