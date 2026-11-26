#!/bin/bash

# Gerenciar postgresql clusters


## adicionar mais um cluster postgresql

##  os scripts estão no pacote postgresql-common (debian/ubuntu)

## criação do cluster
pg_createcluster 17 novo_cluster -d /var/lib/postgresql/novo_cluster -p 5433

# reload do systemd 

systemctl daemon-reload

## stop | start pelo pg_ctlcluster ou systemd

pg_ctlcluster 17 novo_cluster stop

systemctl start postgresql@17-novo_cluster

## listar os clusters

pg_lsclusters

## apagar um cluster

pg_dropcluster 17 novo_cluster
