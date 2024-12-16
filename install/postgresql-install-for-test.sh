#!/bin/bash
#
# Bash script para compilar o PostgreSQL 
# no Debian Linux (12+) ou Arch Linux / Manjaro.
#
# Não usar em produção.
#
# Autor: Ricardo Cassiano


echo "
Bash script para compilar o PostgreSQL 
no Debian Linux (12+) ou Arch Linux / Manjaro.

Não usar em produção!!!!

Adaptado da documentação oficial:

https://www.postgresql.org/docs/current/installation.html

"

sleep 1



read -r -p "Digite a versão que quer instalar (ex: 15.10, 16.6, 17.2)": VERSAO

read -r -p "Digite a pasta onde quer instalar (ex: /opt/pgsql)": PASTA_INSTALACAO

VERSAO_PRINCIPAL=$(cut -c 1-2 <<< "$VERSAO")

sudo mkdir -p "${PASTA_INSTALACAO}" 

PASTA_COMPILACAO="$HOME"/compilacao

mkdir -p "${PASTA_COMPILACAO}"



cd "${PASTA_COMPILACAO}"/ || return


# Instalar os pacotes necessários para a compilação

if [ "$(grep -E '^ID=' /etc/os-release)" = "ID=debian" ]; then
	sudo apt-get -y install  bison flex llvm clang zlib1g-dev \
	lib{ssl,systemd,readline,xslt1,xml2}-dev m4 make autoconf \
	pkgconf flex gcc make guile-3.0-dev patch automake  python3-dev	
elif [[ "$(grep -E '^ID=' /etc/os-release)" = "ID=arch" || "$(grep -E '^ID=' /etc/os-release)" = "ID=manjaro" ]]; then
    sudo pacman --noconfirm --needed -S bison \
	flex llvm clang zlib openssl readline libxslt \
	libxml2 m4 make autoconf pkgconf guile gcc patch \
	python automake wget
else
	echo "Esse script é para Debian ou Arch Linux e derivados!!"
	exit
fi


# Download do código fonte

wget -c https://ftp.postgresql.org/pub/source/v"$VERSAO"/postgresql-"$VERSAO".tar.gz

tar -xf postgresql-"$VERSAO".tar.gz

cd postgresql-"$VERSAO" || return

# Executa a compilação

CXX=/usr/bin/g++ PYTHON=python3 ./configure \
--prefix="${PASTA_INSTALACAO}"/"$VERSAO_PRINCIPAL" \
--with-pgport=5454 \
--with-python \
--with-openssl \
--with-systemd \
--with-libxml \
--with-libxslt

make world-bin

sudo make install-world-bin

cd src/interfaces/libpq || return

make

sudo make install

# Cria o usuário postgres, caso não exista

if [ "$(grep -c '^postgres:' /etc/passwd)" = 0 ]; then
	sudo useradd --system --shell /usr/bin/bash  --no-create-home postgres
else
    echo "Usuário postgres já existe"
fi

# Ajusta permissão da pasta de instalação

sudo chown -R postgres:postgres "${PASTA_INSTALACAO}"

echo "Instalação concluída!!"
