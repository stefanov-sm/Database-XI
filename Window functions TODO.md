## Window functions TODO
There are 3 tables, DDL below
```sql
create table person
(
 id serial primary key not null,
 name text not null,
 details jsonb not null default '{}' -- many personal details here
);

create table initial_ballance
(
 id serial primary key not null,
 person_id integer not null references person(id),
 ballance_date date,
 ballance numeric
);
create table transactions
