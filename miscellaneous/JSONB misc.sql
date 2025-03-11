--------------------------------------------------------------------------------
create or replace function jsonb_text(j jsonb)
returns text immutable strict language sql as
$$
  select j #>> '{}'
$$;
-- unit test
--------------------------------------------------------------------------------
select ('{"key":"X100"}'::jsonb)['key'],
       jsonb_text(('{"key":"X100"}'::jsonb)['key']);
--------------------------------------------------------------------------------

create or replace function jsonpath_lint(jtext text, jpath text)
returns table (result_value text, result_type text) immutable language plpgsql as
$$
declare
  etext text; edetails text; ehint text;
  LF constant text := e'\n'; ERR constant text := '*** Error ***';
begin
  return query
  with t as (select jsonb_path_query(jtext::jsonb, jpath::jsonpath) res)
    select res::text, coalesce(jsonb_typeof(res)::text, 'NULL') from t;
exception when others then
  get stacked diagnostics
    etext := MESSAGE_TEXT, edetails := PG_EXCEPTION_DETAIL, ehint := PG_EXCEPTION_HINT;
  return query
  select
    concat_ws(LF, ERR, nullif(etext, ''), nullif(edetails, ''), nullif(ehint, '')), 
    null;
end;
$$;
-- unit test
--------------------------------------------------------------------------------
select * from jsonpath_lint(
  '{"key":[11,12,13,14,15], "value":{"current":false}}', 
  '$.value.current'
 );
--------------------------------------------------------------------------------
