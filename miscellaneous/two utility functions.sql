-- Both functions use a correlated scalar subquery
--------------------------------------------------

-- drop function if exists find_routine;
create or replace function find_routine (partial_name text)
returns table (
	routine_schema text, 
	routine_name text, 
	routine_type text, 
	return_type text, 
	arguments text[], 
	routine_body text
) as $function$
 select
    routine_schema, routine_name,
    routine_type, data_type,
    (
     select array_agg(format('%s %I %s', 
              parameter_mode,
              parameter_name,
              data_type
            ) order by ordinal_position)
     from information_schema.parameters as p
     where p.specific_name = r.specific_name
    ),
    routine_definition
 from information_schema.routines as r
 where routine_name ~* partial_name;
$function$ language sql;

-- drop function if exists find_table;
create or replace function find_table (partial_name text)
returns table (
    table_schema text, 
    table_name text, 
    table_type text, 
    columns text[] 
) as $function$
 select
    table_schema, table_name,
    table_type, 
    (
     select array_agg(concat_ws(' ',
         format('%I', column_name),
         data_type,
         case when is_nullable = 'NO' then 'not null' end,
         'default ' || column_default
        ) order by ordinal_position)
     from information_schema.columns as c
     where t.table_name = c.table_name 
       and t.table_schema = c.table_schema
    ) from information_schema.tables as t
 where table_name ~* partial_name;
$function$ language sql;
