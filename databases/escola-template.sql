/*

Banco de dados escola fictício

Apenas para testes



*/


CREATE DATABASE escola ;

\c escola



CREATE TABLE situacao (
    id int not null primary key,
    descricao text,
    data_criacao timestamp default current_timestamp,
    data_atualizacao timestamp
) ;


INSERT INTO situacao (id, descricao)
VALUES (0, 'EXCLUIDO'), (1, 'ATIVO') ;



CREATE TABLE professor (
    id bigserial not null primary key,
    descricao text,
    situacao_id int not null default 1 references situacao(id),
    data_criacao timestamp default current_timestamp,
    data_atualizacao timestamp
) ;



CREATE TABLE aluno (
    id bigserial not null primary key,
    descricao text,
    situacao_id int not null default 1 references situacao(id),
    professor_id bigint not null  references professor(id),
    data_criacao timestamp default current_timestamp,
    data_atualizacao timestamp
) ;