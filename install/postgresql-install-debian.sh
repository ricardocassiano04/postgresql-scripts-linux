#!/bin/bash
#
# Script bash para compilar e instalar o PostgreSQL 
# no Linux Debian (12+) / Ubuntu (22.04+).
#
#
# Autor: Ricardo Cassiano


echo "
Script bash para compilar e instalar o PostgreSQL 

no Linux Debian (12+) / Ubuntu (22.04+).

Adaptado da documentação oficial:

https://www.postgresql.org/docs/current/installation.html

"

sleep 1


read -r -p "Digite a versão que você quer instalar (ex: 15.6, 16.2)": VERSAO

read -r -p "Digite o caminho da instalação (exemplo: /opt/pgsql)": PASTA_INSTALACAO


# Usar apenas o número da versão principal na pasta de instalação

sudo mkdir -p "${PASTA_INSTALACAO}"

VERSAO_PRINCIPAL=$(cut -c 1-2 <<< "$VERSAO")


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
--prefix="${PASTA_INSTALACAO}"/"${VERSAO_PRINCIPAL}" \
--with-pgport=5433 \
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
    echo "postgres user already created"	
fi

# Ajusta permissão da pasta de instalação

sudo chown -R postgres:postgres "${PASTA_INSTALACAO}"

# Verifica se já existe uma instalação do postgresql. 
# Caso tenha, configura essa instalação com a padrão do sistema
# ajustando o PATH dos binários e bibliotecas.

command -v psql >/dev/null 2>&1 || \
{ sudo tee -a /etc/profile.d/pgsql.sh>>/dev/null<<EOF
LD_LIBRARY_PATH="${PASTA_INSTALACAO}"/"${VERSAO_PRINCIPAL}"/lib
export LD_LIBRARY_PATH

PATH="${PASTA_INSTALACAO}"/"${VERSAO_PRINCIPAL}"/bin:$PATH
export PATH

MANPATH="${PASTA_INSTALACAO}"/"${VERSAO_PRINCIPAL}"/share/man:$MANPATH
export MANPATH
EOF
sudo /sbin/ldconfig "${PASTA_INSTALACAO}"/"${VERSAO_PRINCIPAL}"/lib
sudo chmod +x /etc/profile.d/pgsql.sh
exit 1; }

# Cria / recria o serviço do postgresql.

sudo systemctl stop postgresql"${VERSAO_PRINCIPAL}".service

sudo rm  -f /etc/systemd/system/postgresql"${VERSAO_PRINCIPAL}".service

sudo tee -a /etc/systemd/system/postgresql"${VERSAO_PRINCIPAL}".service>>/dev/null<<EOF

[Unit]
Description=PostgreSQL "$VERSAO_PRINCIPAL" database server
Documentation=man:postgres(1)
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
User=postgres
ExecStart="${PASTA_INSTALACAO}"/"${VERSAO_PRINCIPAL}"/bin/postgres -D "${PASTA_INSTALACAO}"/"${VERSAO_PRINCIPAL}"/data
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
KillSignal=SIGINT
TimeoutSec=infinity

[Install]
WantedBy=multi-user.target
EOF

# Desabilita por padrão o serviço do postgresql.

sudo systemctl disable postgresql"${VERSAO_PRINCIPAL}".service

sudo systemctl daemon-reload


echo "Instalação finalizada. 

Importante: Executar o initdb antes de iniciar o postgresql!!

Por padrão, o serviço postgresql$VERSAO_PRINCIPAL está desabilitado na inicialização do sistema.

Você pode habilitá-lo executando: 

sudo systemctl enable postgresql$VERSAO_PRINCIPAL.service
"
