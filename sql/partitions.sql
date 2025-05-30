/*
https://www.postgresql.org/docs/current/ddl-partitioning.html

*/

select 
    distinct inhparent::regclass 
from pg_inherits ;



-- criar tabela e adicionar partições

CREATE TABLE parted_mytable_202407 (LIKE parted_mytable_202406 INCLUDING ALL) ;

ALTER TABLE ONLY public.mytable ATTACH PARTITION public.parted_mytable_202407 
FOR VALUES FROM ('2024-07-01') TO ('2024-08-01');