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

-- close connectios


 -- view connection to database

 select pid, datname, backend_start, substring(query, 0, 15) 
from pg_stat_activity 
where datname = 'database';
