#!/bin/bash
#
# Configura o repositório e instala o PgAdmin (desktop) no Debian 12 / Ubuntu e Linux Mint.
# 
#
# Autor: Ricardo Cassiano
#
#


echo "
 
Verificando se sua ditribuição é compatível com o script...

"

sleep 1

# Verificar a distruição

source /etc/os-release

if [[ "$ID" == "linuxmint" || "$ID" == "ubuntu" ]]; then
   distro="$UBUNTU_CODENAME"
   echo "Sua distro $PRETTY_NAME é suportada. Iniciando a instalação..."
   
elif [[ "$ID" == "ubuntu" ]]; then
   distro="$VERSION_CODENAME"
   echo "Sua distro $PRETTY_NAME é suportada. Iniciando a instalação..."
   
elif [[ "$ID" == "debian"  ]]; then
	versao=${VERSION_ID%%.*}
	
	if ((  versao < 11 )); then
		echo "Sua distro $PRETTY_NAME não é suportada por este script. Saindo..."
		exit 0
	elif (( versao > 10 )); then
		distro="$VERSION_CODENAME"
		echo "Sua distro $PRETTY_NAME é suportada. Iniciando a instalação..."
	fi
fi




echo "
 
 Configurando o repositório e instala o PgAdmin (desktop) no $ID $PRETTY_NAME .



PgAdmin

https://www.pgadmin.org/download/pgadmin-4-apt/

"

sleep 1
	

#  Instalar os pacotes necessários para configurar os repositótios

sudo apt-get -y install curl lsb-release ca-certificates

# Importa a chave do repositório 

curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg


# Adicionar repositórios

sudo tee -a /etc/apt/sources.list.d/pgadmin.list>>/dev/null<<EOF

deb [arch=amd64 signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/"${distro}" pgadmin4 main

EOF


# Atualiza repositórios e instala os pacotes

sudo apt-get update


sudo apt-get -y install pgadmin4-desktop 


echo "Instalação finalizada!!"


