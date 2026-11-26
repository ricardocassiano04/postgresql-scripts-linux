/* 

Procedure para criar índice em FKs que não tem índice.

Passamos o nome da tabela referenciada como parâmetro e a
procedure que vai identificar as outras tabelas que tem chaves estrangeiras
referenciando essa tabela que não tem índice.


*/


-- DROP PROCEDURE sp_criar_indices_fks (tabela text) ;


CREATE OR REPLACE PROCEDURE sp_criar_indices_fks (tabela text)
LANGUAGE plpgsql
AS $$
DECLARE
    indice_fk TEXT;

BEGIN
    FOR indice_fk IN
        SELECT replace(lista.comando, '.', '_')
        FROM (
            SELECT 
                'CREATE INDEX idx_' 
                || la.attrelid::regclass
                || '_'
                || ra.attrelid::regclass
                || '_'
                || ra.attname
                || ' ON '
                || la.attrelid::regclass
                || ' ('
                || la.attname 
                || ');' as comando
            FROM pg_constraint AS c
            JOIN pg_attribute AS la
                ON la.attrelid = c.conrelid
                    AND la.attnum = c.conkey[1]
            JOIN pg_attribute AS ra
                ON ra.attrelid = c.confrelid
                    AND ra.attnum = c.confkey[1]
            WHERE c.confrelid = tabela::regclass
            AND c.contype = 'f'
            AND ra.attname = 'id'
            AND cardinality(c.confkey) = 1
            AND EXISTS (
                SELECT 1
                FROM information_schema.tables
                WHERE information_schema.tables.table_name = quote_ident(conrelid::regclass::text)
                AND information_schema.tables.table_name <> quote_ident(c.confrelid::regclass::text)
               -- AND information_schema.tables.table_schema = 'public'
            )
            ) AS lista
    LOOP
        BEGIN
            EXECUTE indice_fk;
            RAISE NOTICE 'Executando a criação do índice - %', indice_fk;
            
        EXCEPTION
            WHEN duplicate_table THEN
                RAISE NOTICE 'O índice já existe - %', indice_fk;
        END;
        commit;
    END LOOP;

END
$$;