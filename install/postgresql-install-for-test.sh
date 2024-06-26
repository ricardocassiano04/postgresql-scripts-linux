#!/bin/bash
#
# Script bash para compilar e instalar o PostgreSQL 
# no Linux Debian (12+) / Ubuntu (22.04+).
#
# Apenas para teste.
#
# Autor: Ricardo Cassiano


echo "
Script bash para compilar e instalar o PostgreSQL 

no Linux Debian (12+) / Ubuntu (22.04+).

Adaptado da documentação oficial:

https://www.postgresql.org/docs/current/installation.html

"

sleep 1

# TODO
# Usar wget ou curl para pegar as versões disponíveis no ftp do postgresql


read -r -p "Digite a versão que você quer instalar (ex: 15.7, 16.3, 17beta1)": VERSAO

read -r -p "Digite a pasta onde quer instalar (ex: /opt/pgsql)": PASTA_INSTALACAO

VERSAO_PRINCIPAL=$(cut -c 1-2 <<< "$VERSAO")

sudo mkdir -p "${PASTA_INSTALACAO}" 

PASTA_COMPILACAO="$HOME"/compilacao

mkdir -p "${PASTA_COMPILACAO}"



cd "${PASTA_COMPILACAO}"/ || return

# Instala os pacotes necessários para a compilação

sudo apt-get -y install  bison flex llvm clang zlib1g-dev \
lib{ssl,systemd,readline,xslt1,xml2}-dev m4 make autoconf \
pkgconf flex gcc make guile-3.0-dev patch automake  python3-dev

# Download do código fonte

wget -c https://ftp.postgresql.org/pub/source/v"$VERSAO"/postgresql-"$VERSAO".tar.gz

tar -xf postgresql-"$VERSAO".tar.gz

cd postgresql-"$VERSAO" || return

# Executa a compilação

CXX=/usr/bin/g++ PYTHON=python3 ./configure \
--prefix="${PASTA_INSTALACAO}"/"$VERSAO_PRINCIPAL" \
--with-pgport=5435 \
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

# Cria o usuário postgres, caso não exista

if [ "$(grep -c '^postgres:' /etc/passwd)" = 0 ]; then
	sudo useradd --system --shell /usr/bin/bash  --no-create-home postgres
else
    echo "Usuário postgres já existe"
fi

# Ajusta permissão da pasta de instalação

sudo chown -R postgres:postgres "${PASTA_INSTALACAO}"

echo "Instlação concluída!!" 
