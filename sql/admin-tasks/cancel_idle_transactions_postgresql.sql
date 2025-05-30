--
-- transactions not active
--

select
  datname, pid, application_name, state_change, substring(query, 0, 60)
from
  pg_stat_activity
where
  state in ('idle', 'idle in transaction', 'idle in transaction (aborted)', 'disabled')
  and pid <> pg_backend_pid()
  and application_name <> 'psql'
  and datname <> 'postgres'
  and state_change <= now() - interval '15min';


-- kill transactions not active



select
  pg_terminate_backend(pid)
from
  pg_stat_activity
where
  state in ('idle', 'idle in transaction', 'idle in transaction (aborted)', 'disabled')
  and pid <> pg_backend_pid()
  and application_name <> 'psql'
  and datname <> 'postgres'
  and state_change <= now() - interval '15min';
  

-- kill a especifi pid
 
SELECT pg_cancel_backend(pid);

select pg_terminate_backend(pid); -- force

