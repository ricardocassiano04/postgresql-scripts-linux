#!/bin/bash
#
# Configura o repositório e instala o PostgreSQL no Fedora Linux
# 
#
# Autor: Ricardo Cassiano
#
# Referência: https://www.postgresql.org/download/linux/redhat/
#
#

# Verificar a distribuição

source /etc/os-release

if [[ "$ID" != "fedora"  ]]; then   
   echo "Sua distro $PRETTY_NAME não é suportada. Saindo..."
   exit 0
   
elif [[ "$ID" == "fedora"  ]]; then
	versao=${VERSION_ID%%.*}
	
	if ((  versao < 42 )); then
		echo "Sua distro $PRETTY_NAME não é suportada por este script. Saindo..."
		exit 0
	elif (( versao > 41 )); then		
		echo "Sua distro $PRETTY_NAME é suportada. Iniciando a instalação..."
	fi
fi


echo "

Configurando o repositório e instalando o PostgreSQL no Fedora Linux

"

sleep 2


read -r -p "Digite a versão que você quer instalar (ex: 17, 18)": VERSAO_POSTGRES


echo "Comandos de configurações conforme documentação em https://www.postgresql.org/download/linux/redhat/"

sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/F-"${versao}"-x86_64/pgdg-fedora-repo-latest.noarch.rpm

sudo dnf install -y postgresql"${VERSAO_POSTGRES}"-server

sudo /usr/pgsql-"${VERSAO_POSTGRES}"/bin/postgresql-"${VERSAO_POSTGRES}"-setup initdb
sudo systemctl enable postgresql-"${VERSAO_POSTGRES}"
sudo systemctl start postgresql-"${VERSAO_POSTGRES}"


echo "Instalação finalizada!!"
