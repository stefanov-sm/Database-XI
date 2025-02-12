-- find_* unctions use a correlated scalar subquery
--------------------------------------------------

-- drop function if exists find_routine;
create or replace function find_routine (partial_name text)
returns table (
	routine_full_name text, 
	routine_type text, 
	return_type text, 
	arguments text[], 
	routine_body text
) as $function$
 select
    format('%I.%I', routine_schema, routine_name),
    routine_type, data_type,
    (
     select array_agg(format('%s %I %s', 
              parameter_mode,
              coalesce(parameter_name, '$'), -- anonymous positional arguments
              data_type
            ) order by ordinal_position)
     from information_schema.parameters as p
     where p.specific_name = r.specific_name
    ),
    routine_definition
 from information_schema.routines as r
 where routine_name ~* partial_name
   and routine_schema not in ('information_schema', 'pg_catalog') 
 order by routine_name, routine_schema;
$function$ language sql;

--------------------------------------------------

-- drop function if exists find_table;
create or replace function find_table (partial_name text)
returns table (
    table_full_name text, 
    table_type text, 
    columns text[] 
) as $function$
 select
    format('%I.%I', table_schema, table_name),
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
    ) 
 from information_schema.tables as t
 where table_name ~* partial_name
   and table_schema not in ('information_schema', 'pg_catalog')
 order by table_name, table_schema;
$function$ language sql;

--------------------------------------------------

create or replace function decode_jwt(jwt text)
returns table (pos integer, contents text) language sql immutable as
$$
with parts as (
  select * from regexp_split_to_table(jwt, '\.') with ordinality as t(x, pos)
)
select pos,
  case when pos = 3 then x
  else convert_from(decode(rpad(translate(x, '-_', '+/'), 4*((length(x)+3)/4), '='), 'base64'), 'utf-8')
  end
from parts order by pos;
$$;

-- Unit test -------------------------------------

select * from decode_jwt('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c');
