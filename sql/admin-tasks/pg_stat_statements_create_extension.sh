#!/bin/bash
#
# Author: Ricardo Cassiano
#
# Create pg_stat_statements postgresql extension in all databases at once (including template1)
# 
# 
# Must be executed with postgres user on linux with trust authentication method activated
# or 
# 

databases_to_alter=$(psql -U postgres -d postgres -A -t -c " select datname from pg_database where datname <> 'template0';")
for bases in ${databases_to_alter}
do
 echo Starting create pg_stat_statements extension for  "${bases}";
 psql -U postgres -d "${bases}" -1 -c "CREATE EXTENSION pg_stat_statements;";
 echo Finished create pg_stat_statements extension for  "${bases}";
done;