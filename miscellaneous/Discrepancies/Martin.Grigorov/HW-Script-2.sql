DO $$ 
DECLARE
    col_name RECORD;
    sql_query TEXT := 'SELECT t1.id';
    discrepancy_sql TEXT := '';
BEGIN
    FOR col_name IN 
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = 'table1' AND column_name <> 'id'
    LOOP
        sql_query := sql_query || ',
                    CASE 
                        WHEN t1.' || col_name.column_name || ' IS DISTINCT FROM t2.' || col_name.column_name || ' 
                        THEN ''Difference in ' || col_name.column_name || ': '' || COALESCE(t1.' || col_name.column_name || '::TEXT, ''NULL'') 
                        || '' vs '' || COALESCE(t2.' || col_name.column_name || '::TEXT, ''NULL'') 
                        ELSE NULL 
                    END AS discrepancy_' || col_name.column_name;
    END LOOP;

    sql_query := sql_query || ' FROM table1 t1 FULL OUTER JOIN table2 t2 ON t1.id = t2.id';

    FOR col_name IN 
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = 'table1' AND column_name <> 'id'
    LOOP
        discrepancy_sql := discrepancy_sql || 
        ' t1.' || col_name.column_name || ' IS DISTINCT FROM t2.' || col_name.column_name || ' OR';
    END LOOP;

    IF length(discrepancy_sql) > 0 THEN
        discrepancy_sql := left(discrepancy_sql, length(discrepancy_sql) - 3);
        sql_query := sql_query || ' WHERE ' || discrepancy_sql;
    END IF;

    BEGIN
        EXECUTE 'DROP VIEW IF EXISTS comparison_view';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;

    EXECUTE 'CREATE VIEW comparison_view AS ' || sql_query;
    
    RAISE NOTICE 'Generated SQL: %', sql_query;

END $$;
