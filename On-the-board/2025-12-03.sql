-- anonymous block
do $$ 
declare r record;
begin
for r in select delme.i, delme.t from delme loop
	raise notice 'running value is % %' ,r.i, r.t;
	raise exception 'Exception';
end loop;
exception when others then
	raise notice 'Error: % %' ,SQLERRM, SQLSTATE;
end;
$$;

-- function
-- drop function if exists delme_sum(integer);
create or replace function delme_sum(arg_i integer)
returns integer language plpgsql as
-- returns integer language plpgsql SECURITY DEFINER as
$body$  
declare
  sum_is integer;
begin
	select sum(i) into sum_is from delme;
	return sum_is;
end;
$body$;

-- NB Functions can be overloaded
