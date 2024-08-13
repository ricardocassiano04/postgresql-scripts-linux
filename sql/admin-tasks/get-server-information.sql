/*

Author: Ricardo Cassiano

Some basic useful queries to get postgresql server information.



*/

-- show server port
SELECT inet_server_port();

-- current database
SELECT current_database();

-- current user
SELECT current_user;



 -- server addr
SELECT inet_server_addr(); 

-- postgresql cluster version
SELECT version();

-- server uptime
SELECT pg_postmaster_start_time(); -- server startup datetime 
SELECT date_trunc('second', current_timestamp - pg_postmaster_start_time()) as uptime; -- server uptime


-- list databases and some information
SELECT datname, pg_size_pretty(pg_database_size(datname)) as size_, encoding, datcollate, datctype, dattablespace  
FROM pg_database;


-- from bash
psql -l
 -- or psql client
 psql: \l+

-- to enable expanded view
 \x
 


-- count current database tables 

SELECT count(*) 
FROM information_schema.tables 
WHERE table_schema NOT IN ('information_schema', 'pg_catalog');


-- data location

SHOW data_directory;

-- pg_hba.conf location

SHOW hba_file;


-- postgresql.conf location

SHOW config_file;

-- postgresql config

SELECT *
FROM pg_config;

-- postgresql settings

SELECT *
FROM pg_settings;


-- return server port

SELECT inet_server_port();

-- current database

SELECT current_database();

-- current user

SELECT current_user;

-- returns the server IP 
-- (returns NULL if the connection is via socket)

SELECT inet_server_addr(); 



-- tablespaces
--psql
\db+

select * 
from pg_tablespaces ;

-- extensions
-- psql
\dx

select *
from pg_extension ;

-- functions
-- psql
\df

select  routine_name
from information_schema.routines
where routine_type = 'FUNCTION'
and routine_schema = 'public';


-- replication
-- replication_lag_behind_primary

SELECT  
    CASE 
        WHEN pg_is_in_recovery() THEN 0
        ELSE GREATEST (0, EXTRACT(EPOCH FROM (now() - pg_last_xact_replay_timestamp())))
        END AS replication_lag_behind_primary;

