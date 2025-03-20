create table person 
(
  person_name text,
  person_weight integer
)
partition by range(person_weight);

-- set "light" lower bound to unbounded min
create table light partition of person
for values from (minvalue) to (50);

create table medium partition of person
for values from (51) to (90);

create table heavy partition of person
for values from (91) to (1000); -- not very nice

insert into person values 
('Stefan', 95), ('Samuil', 60), ('Borimir', 70), ('Rita', 6);

-- change "heavy" upper bound from 1000 to unbounded max
alter table person detach partition heavy;
alter table person attach partition heavy
for values from (91) to (maxvalue);

select * from person;
select * from light;
select * from medium;
select * from heavy;

create or replace function get_partitions(parent text) 
returns table(schema_name text, table_name text) language sql as
$$
select nsp.nspname, tbl.relname
from pg_catalog.pg_namespace nsp
  join pg_catalog.pg_class tbl
  on nsp.oid = tbl.relnamespace
where tbl.oid in (
  select inhrelid 
  from pg_catalog.pg_inherits
  where  inhparent = parent::regclass
)
$$;

select * from get_partitions('public.person');

-- Result:
-- schema_name|table_name|
-- -----------+----------+
-- public     |medium    |
-- public     |heavy     |
-- public     |light     |
