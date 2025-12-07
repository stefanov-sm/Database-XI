-- drop domain if exists triangle;
-- drop type if exists triplet;

-- CREATE TYPE
create type triplet as (leg_a numeric, leg_b numeric, leg_c numeric);

-- CREATE DOMAIN (A TYPE WITH CONSTRAINTS)
create domain triangle as triplet check (
 (value).leg_a + (value).leg_b > (value).leg_c and 
 (value).leg_a + (value).leg_c > (value).leg_b and 
 (value).leg_b + (value).leg_c > (value).leg_a
);

with t(tr) as 
(
 values 
 ((3,4,5)::triangle),
 ((13,14,15)::triangle),
 ((103,104,105)::triangle)
)
select (tr).leg_a a, (tr).leg_b b, (tr).leg_c + 2 z from t;

-- A SIMPLE FUNCTION WITH DOMAIN triangle
create or replace function tr_add(a triangle, b triangle)
returns triangle language plpgsql as 
$body$
declare 
	retval triangle;
begin
	retval.leg_a := a.leg_a + b.leg_a;
	retval.leg_b := a.leg_b + b.leg_b;
	retval.leg_c := a.leg_c + b.leg_c;
	return retval;
end;
$body$;

select tr_add((3,4,5)::triangle, (13,14,15)::triangle);

create operator + (
 leftarg = triangle,
 rightarg = triangle,
 function = tr_add
);

select (3,4,5)::triangle + (13,14,15)::triangle as tr;

-- TABLE/SET-RETURNING FUNCTIONS

create or replace function tr_table()
returns setof triangle
language plpgsql as
$body$
begin
 return query
 with t(tr) as 
 (
 values 
  ((3,4,5)::triangle),
  ((13,14,15)::triangle),
  ((103,104,105)::triangle)
 )
 select 
	(tr).leg_a * 2, (tr).leg_b * 2, (tr).leg_c * 2 from t;
end;
$body$;

select * from tr_table();
