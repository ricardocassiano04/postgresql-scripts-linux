#!/bin/bash
#
# Bash script para compilar o PostgreSQL 
# no Debian Linux (12+) ou OpenSUSE.
#
# Não usar em produção.
#
# Autor: Ricardo Cassiano


echo "
Bash script para compilar o PostgreSQL 
no Debian Linux (12+) e derivados ou OpenSUSE

Não usar em produção!!!!

Adaptado da documentação oficial:

https://www.postgresql.org/docs/current/installation.html

"

sleep 1


# Verificar distro e instalar os pacotes necessários para a compilação


source /etc/os-release


if [[ "$ID" == "linuxmint" || "$ID" == "ubuntu" ]]; then
   distro="$UBUNTU_CODENAME"
   echo "Sua distro $PRETTY_NAME é suportada. Iniciando a instalação..."
   sudo apt-get -y install  bison flex llvm clang zlib1g-dev \
   lib{ssl,systemd,readline,xslt1,xml2}-dev m4 make autoconf \
   pkgconf flex gcc make guile-3.0-dev patch automake  python3-dev \
   libicu-dev xsltproc llvm-dev libclang-dev

   PYTHON_VERSION=python3
   
elif [[ "$ID" == "opensuse-leap" ]]; then
   distro="$VERSION_CODENAME"
   echo "Sua distro $PRETTY_NAME é suportada. Iniciando a instalação..."
   sudo zypper -n install  bison \
   flex llvm clang zlib openssl readline libxslt \
   llvm-devel clang-devel zlib-devel libopenssl-devel readline-devel libxslt-devel \
   libxml2-devel m4 make autoconf pkgconf guile-devel gcc patch \
   python313-devel automake wget systemd-devel libicu-devel
	
	PYTHON_VERSION=python3.13
   
elif [[ "$ID" == "debian"  ]]; then
	versao=${VERSION_ID%%.*}
	
	if ((  versao < 11 )); then
		echo "Sua distro $PRETTY_NAME não é suportada por este script. Saindo..."
		exit 0
	elif (( versao > 10 )); then
		distro="$VERSION_CODENAME"
		echo "Sua distro $PRETTY_NAME é suportada. Iniciando a instalação..."
	    sudo apt-get -y install  bison flex llvm clang zlib1g-dev \
	    lib{ssl,systemd,readline,xslt1,xml2}-dev m4 make autoconf \
	    pkgconf flex gcc make guile-3.0-dev patch automake  python3-dev \
	    libicu-dev xsltproc llvm-dev libclang-dev

	    PYTHON_VERSION=python3
	fi
fi



read -r -p "Digite a versão que quer instalar (ex: 15.14, 16.10, 17.6, 18.0)": VERSAO

read -r -p "Digite a pasta onde quer instalar (ex: /opt/pgsql)": PASTA_INSTALACAO

VERSAO_PRINCIPAL=$(cut -c 1-2 <<< "$VERSAO")

sudo mkdir -p "${PASTA_INSTALACAO}" 

PASTA_COMPILACAO="$HOME"/compilacao

mkdir -p "${PASTA_COMPILACAO}"



cd "${PASTA_COMPILACAO}"/ || return



# Download do código fonte

wget -c https://ftp.postgresql.org/pub/source/v"$VERSAO"/postgresql-"$VERSAO".tar.gz

tar -xf postgresql-"$VERSAO".tar.gz

cd postgresql-"$VERSAO" || return

# Executa a compilação

CXX=/usr/bin/g++ PYTHON="${PYTHON_VERSION}" ./configure \
--prefix="${PASTA_INSTALACAO}"/"$VERSAO_PRINCIPAL" \
--with-pgport=5454 \
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

echo "Instalação concluída!!"
