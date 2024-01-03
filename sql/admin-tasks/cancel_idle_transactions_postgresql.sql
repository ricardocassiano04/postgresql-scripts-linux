select
  pg_terminate_backend(pid)
from
  pg_stat_activity
where
  state = 'idle'
  and query_start <= now() - interval '180min';