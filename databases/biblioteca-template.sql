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
id bigserial not null primary key,
descricao text
);

CREATE TABLE autor (
    id bigserial not null primary key,
    nome text,
    situacao_id int not null default 1 references situacao(id),
    data_criacao timestamp default current_timestamp,
    data_atualizacao timestamp
) ;


create table categoria (
id bigserial not null primary key,
descricao text UNIQUE,
situacao_id integer not null references situacao (id) default 1,
data_cadastro timestamp default current_timestamp(0),
data_atualizacao timestamp
);
