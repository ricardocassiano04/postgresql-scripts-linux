-- https://www.postgresql.org/docs/15/disk-usage.html

-- tamanho das bases

select datname, pg_size_pretty(pg_database_size(datname)) as pg_database_size
from pg_database
order by datname;

SELECT *
FROM pg_class;

SELECT relname, relpages
FROM pg_class
ORDER BY relpages DESC;

SELECT pg_relation_filepath(oid), relpages 
FROM pg_class 
WHERE relname = 'TABLE_NAME';


SELECT relname, relpages
FROM pg_class,
     (SELECT reltoastrelid
      FROM pg_class
      WHERE relname = 'TABLE_NAME') AS ss
WHERE oid = ss.reltoastrelid OR
      oid = (SELECT indexrelid
             FROM pg_index
             WHERE indrelid = ss.reltoastrelid)
ORDER BY relname;


SELECT c2.relname, c2.relpages
FROM pg_class c, pg_class c2, pg_index i
WHERE c.relname = 'TABLE_NAME' AND
      c.oid = i.indrelid AND
      c2.oid = i.indexrelid
ORDER BY c2.relname;


--
-- tamanho das tabelas
-- 


select
relname,
pg_size_pretty(pg_relation_size(relid)) as tamanho_so_tabela,
pg_size_pretty(pg_indexes_size(relid)) as tamanho_indices,
pg_size_pretty(pg_total_relation_size(relid)) as tamanho_total
from pg_catalog.pg_statio_user_tables
where schemaname <> 'pg_catalog'
and schemaname <> 'information_schema'
order by pg_total_relation_size(relid) desc;


SELECT 
      relname AS tabela, 
      n_dead_tup AS dead_tuples, 
      pg_size_pretty(pg_relation_size(relid)),  
      pg_relation_size(relid) as tamanho_bytes 
FROM pg_stat_user_tables 
ORDER BY n_dead_tup DESC ;