-- Implicit cursor in PL/pgSQL 
-- Using a generic record
create or replace function pg_temp.f1()
returns numeric language plpgsql as
$$
declare
  ret_val numeric := 0;
  r record;
begin
  for r in select * from temporal.goods loop
    ret_val := ret_val + r.price;
    raise notice '%', r.goods_name;
  end loop;
  return ret_val;
end;
$$;

-- Using separate variables
create or replace function pg_temp.f2()
returns numeric language plpgsql as
$$
declare
  ret_val numeric := 0;
  var_price numeric;
  var_name text;
begin
  for var_price, var_name in select price, goods_name from temporal.goods loop
    ret_val := ret_val + var_price;
    raise notice '%', var_name;
  end loop;
  return ret_val;
end;
$$;
