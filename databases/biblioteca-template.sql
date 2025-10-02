/*

Banco de dados biblioteca fictício

Apenas para testes

Em desenvolvimento

*/



CREATE DATABASE biblioteca ;

\c biblioteca


CREATE TABLE situacao (
    id int not null primary key,
    descricao text
) ;


INSERT INTO situacao (id, descricao)
VALUES (0, 'EXCLUIDO'), (1, 'ATIVO') ;


create table pais (
id bigint not null primary key generated always as identity,
descricao text
);

create table autor (
    id bigint not null primary key generated always as identity,
    nome text,
    situacao_id int not null default 1 references situacao(id),
    data_criacao timestamp default current_timestamp,
    data_atualizacao timestamp
) ;


create table categoria (
id bigint not null primary key generated always as identity,
descricao text UNIQUE,
situacao_id integer not null references situacao (id) default 1,
data_cadastro timestamp default current_timestamp(0),
data_atualizacao timestamp
);


create table formato (
id bigint not null primary key generated always as identity,
descricao text UNIQUE,
situacao_id integer not null references situacao (id) default 1,
data_cadastro timestamp default current_timestamp(0),
data_atualizacao timestamp
);

insert into formato (descricao)
values ('físico'), ('pdf'), ('epub'), ('mobi');


create table editora (
id bigint not null primary key generated always as identity,
descricao text UNIQUE,
situacao_id integer not null references situacao (id) default 1,
data_cadastro timestamp default current_timestamp(0),
data_atualizacao timestamp
);


create table livro (
id bigint not null primary key generated always as identity,
titulo text,
categoria_id bigint references categoria (id),
editora_id bigint references editora (id),
ano_publicao integer,
ano_livro integer,
pais_id bigint references pais (id),
qtde_paginas bigint,
formato_id bigint references formato (id),
situacao_id integer not null references situacao (id) default 1,
data_cadastro timestamp default current_timestamp(0),
data_atualizacao timestamp
);


create table livro_autor (
id bigint not null primary key generated always as identity,
livro_id bigint not null references livro (id),
autor_id bigint not null references autor (id),
data_cadastro timestamp default current_timestamp(0),
data_atualizacao timestamp,
unique (livro_id, autor_id)
);