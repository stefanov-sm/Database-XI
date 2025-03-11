create or replace function pg_input_is_valid(t text, target_t text) 
returns boolean immutable language plpgsql as 
$$ 
  begin
    execute format('select %L :: %s', t, taret_t);
    return true;
  exception when others then 
    return false;
  end;
$$;

select * from pg_input_is_valid('123', 'int');
select * from pg_input_is_valid('some text', 'int');

create type custom_type as (num numeric, t text);
select * from pg_input_is_valid('(123, text)', 'custom_type');
select * from pg_input_is_valid('(123, "text")', 'custom_type');

create or replace function c_random(one numeric, two numeric)
returns numeric volatile language sql as
$$
	select random()*(two - one) + one; 
$$;

create or replace function c_random(one integer, two integer)
returns integer volatile language sql as
$$
	select random()*(two - one) + one; 
$$;

select * from c_random(3.1, 18.2);
select * from c_random(1, 26);

drop type custom_type;
drop function public.pg_input_is_valid;
drop function c_random(numeric, numeric);
drop function c_random(integer, integer);

