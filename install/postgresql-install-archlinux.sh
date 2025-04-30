#!/bin/bash
#
# Script bash instalar o PostgreSQL no Arch Linux.
#
#
# Autor: Ricardo Cassiano


echo "
Script bash instalar o PostgreSQL no Arch Linux.
"

sleep 1

sudo pacman -Syu

sudo pacman -S postgresql postgresql-docs python-psycopg2

sudo su - postgres

/usr/bin/initdb -D /var/lib/postgres/data --auth-local=peer --auth-host=scram-sha-256

exit