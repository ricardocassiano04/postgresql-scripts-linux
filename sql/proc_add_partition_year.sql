/*

Procedure para adicionar partições às tabelas mytable particionadas.

Adiciona um ano a partir do mês atual.

Particionamento é uma coisa muito específica.

Então deve-se personalizar a procedure para atender.

A procedure abaixo é apenas um modelo.

*/



CREATE OR REPLACE PROCEDURE proc_add_year_partitions_to_mytable()
LANGUAGE plpgsql

AS
$$

DECLARE partition_information RECORD;
DECLARE create_partition text;
DECLARE attach_partition text;
DECLARE qt_month integer;


BEGIN

    FOR partition_information IN
    SELECT DISTINCT ON (client_id)
        substring(tablename, 0, length(tablename) - 6)  || '_' ||
        to_char(((year_month::text || '01')::date + interval '1 month')::date, 'YYYYMM') as new_table,
        tablename, 
        year_month, 
        client_id, 
        ((year_month::text || '01')::date + interval '1 month')::date as initial_partition_date, 
        ((year_month::text || '01')::date + interval '2 month')::date as end_partition_date,
        replace(substring(tablename, 0, length(tablename) - 6), 'partitioned_', '') as parent_table,
        DATE_PART('year', age(current_date + interval '12 month', ((year_month::text || '01')::date)::date)) * 12 +
        DATE_PART('month', age(current_date + interval '12 month', ((year_month::text || '01')::date)::date)) as diff_month
    FROM (
        SELECT
            tablename,
            SUBSTRING(tablename FROM 'partitioned_mytable_([0-9]+)_([0-9]{6})') AS client_id,
            SUBSTRING(tablename FROM '_([0-9]{6})$') AS year_month
        FROM 
            pg_tables
        WHERE 
            tablename LIKE 'partitioned_mytable_%'
        ) AS partition_tables
    ORDER BY 
        client_id,
        year_month DESC

    LOOP
        BEGIN

            qt_month = 1 ;

            WHILE qt_month <= partition_information.diff_month  LOOP

            create_partition := 'CREATE TABLE ' || partition_information.new_table || ' ( LIKE ' || partition_information.tablename || ' INCLUDING ALL );' ;
            attach_partition :=  'ALTER TABLE ' || partition_information.parent_table || ' ATTACH PARTITION ' || partition_information.new_table || ' FOR VALUES FROM (' ||
            '''' || partition_information.initial_partition_date || '''' || ') TO (' || '''' || partition_information.end_partition_date || '''' || ');';

                  

            RAISE NOTICE 'Creating partition - %', create_partition; 
            EXECUTE create_partition ;
            RAISE NOTICE 'Attaching partition - %', attach_partition; 
            EXECUTE attach_partition ;          

            qt_month = qt_month + 1;
            partition_information.new_table := SUBSTRING(partition_information.new_table, 0, LENGTH(partition_information.new_table) - 6) || '_' || to_char(((partition_information.initial_partition_date + interval '1 month' )::date), 'YYYYMM');
            partition_information.initial_partition_date := (partition_information.initial_partition_date + interval '1 month')::date;
            partition_information.end_partition_date := (partition_information.end_partition_date + interval '1 month' )::date;

            END LOOP;


        END;
        COMMIT;
    END LOOP;

END;

$$;
