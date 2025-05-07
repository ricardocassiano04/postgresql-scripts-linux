# Anotações sobres os scripts


## sp_criar_indices_fks.sql

### Procedure para criar índice em FKs que não tem índice.

Passamos o nome da **tabela referenciada** como parâmetro e a
procedure que vai identificar as outras tabelas que tem chaves estrangeiras
referenciando essa tabela que não tem índice.


### Por exemplo:

No banco de dados escola, as tabelas aluno e professor tem FK (`situacao_id`) para a tabela situacao.
E a tabela aluno tem FK (`professor_id`) para a tabela professor.

No entanto, esses campos estão sem índice.

A procedure `sp_criar_indices_fks` identifica isso e cria os índices.


```sql   

-- criar banco de dados 
CREATE DATABASE escola ;

\c escola


-- criação das tabelas

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
```



#### Testando:


Crie a procedure executando o [sp_criar_indices_fks.sql](./sp_criar_indices_fks.sql)

```sql 


escola=# call sp_criar_indices_fks ('situacao') ;
NOTICE:  Executando a criação do índice - CREATE INDEX idx_professor_situacao_id ON professor (situacao_id);
NOTICE:  Executando a criação do índice - CREATE INDEX idx_aluno_situacao_id ON aluno (situacao_id);
CALL
escola=# call sp_criar_indices_fks ('professor') ;
NOTICE:  Executando a criação do índice - CREATE INDEX idx_aluno_professor_id ON aluno (professor_id);
```      

#### Índices criados:


```sql   
escola=# select tablename, indexname, indexdef from pg_indexes where tablename in ('aluno', 'professor'); 
tablename |         indexname         |                                       indexdef                                       
-----------+---------------------------+--------------------------------------------------------------------------------------
professor | professor_pkey            | CREATE UNIQUE INDEX professor_pkey ON public.professor USING btree (id)
aluno     | aluno_pkey                | CREATE UNIQUE INDEX aluno_pkey ON public.aluno USING btree (id)
professor | idx_professor_situacao_id | CREATE INDEX idx_professor_situacao_id ON public.professor USING btree (situacao_id)
aluno     | idx_aluno_situacao_id     | CREATE INDEX idx_aluno_situacao_id ON public.aluno USING btree (situacao_id)
aluno     | idx_aluno_professor_id    | CREATE INDEX idx_aluno_professor_id ON public.aluno USING btree (professor_id)
(5 rows)
```





