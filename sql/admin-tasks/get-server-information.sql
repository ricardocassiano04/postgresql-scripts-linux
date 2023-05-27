/*
Author: Ricardo Cassiano

Some basic queries to get postgresql server information.



*/


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

-- server version

SELECT version();

-- server uptime

SELECT pg_postmaster_start_time(); -- date/time server start
SELECT date_trunc('second', current_timestamp - pg_postmaster_start_time()) as uptime; -- time active

-- query cluster databases (\l in psql)
SELECT datname 
FROM pg_database;


-- count tables

SELECT count(*) 
FROM information_schema.tables 
WHERE table_schema NOT IN ('information_schema', 'pg_catalog');

