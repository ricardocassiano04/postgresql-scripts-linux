#!/bin/bash
#
# Configura o repositório e instala o PostgreSQL no OpenSUSE Leap / Tumbleweed.
# 
#
# Autor: Ricardo Cassiano
#
#
# TODO
# Validar versão digitada pelo usuário


echo "
 

Configura o repositório e instala o PostgreSQL no OpenSUSE Leap / Tumbleweed.

Adicionando o repositório:

"




if  [[ "$(grep -E '^ID=' /etc/os-release)" = "ID=\"opensuse-tumbleweed\"" ]]; then

	sudo zypper addrepo http://download.opensuse.org/repositories/server:/database:/postgresql/openSUSE_Tumbleweed/ PostgreSQL
	
	sudo zypper --gpg-auto-import-keys refresh

elif [[ "$(grep -E '^ID=' /etc/os-release)" = "ID=\"opensuse-leap\"" ]]; then

	sudo zypper addrepo http://download.opensuse.org/repositories/server:/database:/postgresql/16.0/ PostgreSQL
	
	sudo zypper --gpg-auto-import-keys refresh
else
	echo "Você não está executando o Linux OpenSUSE!!"
	exit
fi



sleep 2



read -r -p "Digite a versão que você quer instalar (ex: 15, 17)": VERSAO


# Atualiza repositórios e instala os pacotes

sudo zypper refresh

sudo zypper -n install postgresql"${VERSAO}" \
postgresql"${VERSAO}"-{contrib,docs,server,pg_repack,plpython}


# Define a versão escolhida pelo usuário como a padrão

sudo update-alternatives --set postgresql /usr/lib/postgresql"${VERSAO}"


echo "Instalação finalizada!!"
