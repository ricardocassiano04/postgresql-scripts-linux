/*

Author: Ricardo Cassiano

Activate pg_stat_statements

https://www.postgresql.org/docs/current/pgstatstatements.html



 First run pg_stat_statements_create_extension script.
 It will create the pg_stat_statements extension in all databases of your cluster.

 
Change postgresql.conf adding above parameters (create them if not exists):

shared_preload_libraries= 'pg_stat_statements'
pg_stat_statements.max = 10000
pg_stat_statements.track = top
pg_stat_statements.track_utility = on



 
*/


-- Choose a database and then create a table for insert rows from pg_stat_statements
-- You can create a cron job to do the inserts and reset pg_stat_stamentes on daily




CREATE TABLE query_stats (
 id bigserial primary key,
 created_at timestamp default current_timestamp,
 userid bigint not null,
 usename text not null,
 dbid bigint not null,
 datname text not null,
 queryid bigint not null,
 query text not null,
 calls bigint not null,
 total_exec_time numeric not null,
 min_exec_time numeric not null,
 max_exec_time numeric not null,
 mean_exec_time numeric not null,
 stddev_exec_time numeric not null
);


-- do the inserts

insert into query_stats (userid,
    usename,
    dbid,
    datname,
    queryid,
    query,
    calls,
    total_exec_time,
    min_exec_time,
    max_exec_time,
    mean_exec_time,
    stddev_exec_time)
select userid,
    usename,
    dbid,
    datname,
    queryid,
    query,
    calls,
    total_exec_time,
    min_exec_time,
    max_exec_time,
    mean_exec_time,
    stddev_exec_time
 from 
    pg_stat_statements
    inner join pg_database on (oid = dbid)
    inner join pg_user on (userid = usesysid);


-- reset pg_stat_staments


select pg_stat_statements_reset();


