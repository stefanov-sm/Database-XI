-- SQL Server style concat operator
create or replace function custom_cat_handler(l text, r text)
returns text language sql parallel safe immutable strict as 
$$
  select l || r;
$$;
create operator + (leftarg = text, rightarg = text, function = custom_cat_handler);
select 'Hello' + ' World!';

-- Parallel resistors operator
------------------------------------------------------
create function custom_parallel(l numeric , r numeric)
returns numeric language sql parallel safe immutable strict as
$$
select l*r/(l+r)
$$;
create operator  || (leftarg = numeric, rightarg = numeric, function = custom_parallel);
select 10 || 20;

-- Cleanup
drop operator  || (numeric, numeric);
drop function custom_parallel;

-- Complex number type (called jtype) 
------------------------------------------------------
create type jtype as (r numeric, i numeric);
select (1,2)::jtype;

create function jtype_add(l jtype, r jtype)
returns jtype language sql parallel safe immutable strict as
$$
  select (l.r + r.r, l.i + r.i)::jtype;
$$;
create operator + (leftarg = jtype, rightarg = jtype,function = jtype_add);

select (1,2)::jtype + (3,4)::jtype;

--

create function jtype_mul(l jtype, r jtype)
returns jtype language sql parallel safe immutable strict as
$$
  select (l.r * r.r - l.i * r.i, l.r * r.i + l.i * r.r)::jtype;
$$;
create operator * (leftarg = jtype, rightarg = jtype,function = jtype_mul);

select (1,2)::jtype * (3,4)::jtype;

-- Casting a numeric to jtype with 0i
------------------------------------------------------
create function num_to_jtype (l numeric) returns jtype
language sql immutable as
$$
 select (l, 0)::jtype;
$$;

create cast (numeric as jtype) with function num_to_jtype;
select 3::numeric::jtype;
