CREATE OR REPLACE FUNCTION compare_rows_by_id(p_table_name text)
RETURNS TABLE (id bigint, compared_column text, value1 text, value2 text, comes_from1 text, comes_from2 text) AS $$
DECLARE
    rec RECORD;
    col_info RECORD;
    sql_query text;
BEGIN
    FOR rec IN EXECUTE format('SELECT id::bigint AS id FROM %I GROUP BY id HAVING COUNT(*) > 0', p_table_name)
    LOOP
        FOR col_info IN 
            SELECT c.column_name, c.data_type
            FROM information_schema.columns AS c
            WHERE c.table_name = p_table_name AND c.column_name NOT IN ('id', 'comes_from')
        LOOP
            sql_query := format(
                'SELECT id::bigint, ' ||
                'MIN(%s)::text AS value1, ' ||
                'MAX(%s)::text AS value2, ' ||
                'MIN(comes_from)::text AS comes_from1, ' ||
                'MAX(comes_from)::text AS comes_from2 ' ||
                'FROM %I ' ||
                'WHERE id = %L ' ||
                'GROUP BY id ' ||
                'HAVING MIN(%s) IS DISTINCT FROM MAX(%s)',
                
                CASE 
                    WHEN col_info.data_type IN ('character varying', 'text', 'character') 
                    THEN format('TRIM(%I)', col_info.column_name)
                    ELSE col_info.column_name 
                END,
                
                CASE 
                    WHEN col_info.data_type IN ('character varying', 'text', 'character') 
                    THEN format('TRIM(%I)', col_info.column_name)
                    ELSE col_info.column_name 
                END,
                
                p_table_name,
                rec.id::bigint,

                col_info.column_name,
                col_info.column_name
            );
            
            FOR rec IN EXECUTE sql_query
            LOOP
                RETURN QUERY SELECT rec.id::bigint, col_info.column_name::text, rec.value1, rec.value2, rec.comes_from1, rec.comes_from2;
            END LOOP;
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;



-- Drop the existing discrepancy table if it exists
DROP TABLE IF EXISTS discrepancy_table;

-- Create the discrepancy_table with data from bigtablea and bigtableb
CREATE TEMP TABLE discrepancy_table AS (
  (
    SELECT *, 'tableA' AS "comes_from" 
    FROM bigtablea  
    EXCEPT ALL
    SELECT *, 'tableA' AS "comes_from" 
    FROM bigtableb
  ) 
  UNION ALL
  (
    SELECT *, 'tableB' AS "comes_from" 
    FROM bigtableb 
    EXCEPT ALL
    SELECT *, 'tableB' AS "comes_from" 
    FROM bigtablea
  )
);

--select * from discrepancy_table ORDER BY id;

-- Call the function with sorting by id and compared_column
SELECT * FROM compare_rows_by_id('discrepancy_table')
ORDER BY id, compared_column;