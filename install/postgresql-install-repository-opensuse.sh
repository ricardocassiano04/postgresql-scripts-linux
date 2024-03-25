#!/bin/bash
#
# Configura o repositório e instala o PostgreSQL no OpenSUSE Tumbleweed.
# 
#
# Autor: Ricardo Cassiano
#
#
# TODO
# Validar versão digitada pelo usuário


echo "
 

Configura o repositório e instala o PostgreSQL no OpenSUSE Tumbleweed.

Adicionando o repositório:

"

sudo zypper addrepo http://download.opensuse.org/repositories/server:/database:/postgresql/openSUSE_Tumbleweed/ PostgreSQL



sleep 2



read -r -p "Digite a versão que você quer instalar (ex: 15, 16)": VERSAO


# Atualiza repositórios e instala os pacotes

sudo zypper refresh

sudo zypper -n install postgresql"${VERSAO}" \
postgresql"${VERSAO}"-{contrib,docs,server}


# Define a versão escolhida pelo usuário como a padrão

sudo update-alternatives --set postgresql /usr/lib/postgresql"${VERSAO}"


echo "Instalação finalizada!!"
