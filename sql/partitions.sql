/*
https://www.postgresql.org/docs/current/ddl-partitioning.html

*/

select 
    distinct inhparent::regclass 
from pg_inherits ;



-- criar tabela e adicionar partições

CREATE TABLE partition_mytable_202409 (LIKE partition_mytable_202508 INCLUDING ALL) ;

ALTER TABLE ONLY public.mytable ATTACH PARTITION public.partition_mytable_202409
FOR VALUES FROM ('2025-09-01') TO ('2024-10-01');