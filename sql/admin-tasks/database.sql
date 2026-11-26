-- databases information


-- list databases
SELECT datname FROM pg_database;

select datname, datdba, encoding, datcollate, datctype, dattablespace 
from pg_database;

-- databases size
select datname, pg_size_pretty(pg_database_size(datname)) 
from pg_database 
order by pg_database_size(datname) desc ;

-- from bash
psql -l
 -- or psql client
 psql: \l+

-- to enable expanded view
 \x

 -- rename database

ALTER DATABASE database_name_ RENAME TO database_name_new;


-- drop database closing current connections to it

DROP DATABASE database_name WITH (FOFCE);


-- cancel currently running query without closing connection


select pg_cancel_backend(pid)
from pg_stat_activity 
where pid = <pid> ;

-- foce a session disconnection
select pg_terminate_backend(pid)
from pg_stat_activity 
where pid = <pid> ;


 -- view connection to database

 select pid, datname, backend_start, substring(query, 0, 15) 
from pg_stat_activity 
where datname = 'database';
