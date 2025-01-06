--------------------------------------------------------------------------------
create or replace function jsonb_text(j jsonb)
returns text immutable strict language sql as
$$
  select j #>> '{}'
$$;

select ('{"key":"X100"}'::jsonb)['key'],
       jsonb_text(('{"key":"X100"}'::jsonb)['key']);
--------------------------------------------------------------------------------
create or replace function jsonpath_lint(jtext text, jpath text) 
returns table (result_value text, result_type text)
immutable strict parallel safe language plpgsql as
$$
begin
  return query
  with t as (select jsonb_path_query(jtext::jsonb, jpath::jsonpath) res)
	select res::text, coalesce(jsonb_typeof(res)::text, 'NULL')
	from t;
exception when others then
  return query select SQLERRM, null;
end;
$$;

select * from jsonpath_lint('{"key":100}', '$.key');
--------------------------------------------------------------------------------
