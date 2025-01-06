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
declare
  err_text text; err_details text; err_hint text;
begin
  return query
  with t as (select jsonb_path_query(jtext::jsonb, jpath::jsonpath) res)
    select res::text, coalesce(jsonb_typeof(res)::text, 'NULL') from t;
exception when others then
  get stacked diagnostics
    err_text := MESSAGE_TEXT, err_details := PG_EXCEPTION_DETAIL, err_hint := PG_EXCEPTION_HINT;	
  return query select
    '*** Error: '||err_text||e'\n'||err_details||e'\n'||err_hint, null;
end;
$$;

select * from jsonpath_lint('{"key":100}', '$.key');
--------------------------------------------------------------------------------
