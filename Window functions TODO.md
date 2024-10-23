## Window functions TODO
There are 3 tables, DDL below
```sql
create table person
(
 id serial primary key not null,
 name text not null,
 details jsonb not null default '{}'
);
-- JSON column "details" is a mimic or several properties
-- and not necessarily an example of proper data design

create table initial_ballance
(
 id serial primary key not null,
 person_id integer not null references person(id),
 ballance_date date not null default '2020-01-01',
 ballance numeric,
 misc jsonb not null default '{}'
);
-- JSON column "misc" is a mimic or possible optional properties
-- and not necessarily an example of proper data design

create table transaction
(
 id serial primary key not null,
 person_id integer not null references person(id),
 transaction_date date not null,
 value numeric, -- negative for money spent
 misc jsonb not null default '{}'
);
-- JSON column "misc" is a mimic or possible optional properties
-- and not necessarily an example of proper data design
```
- What is the ballance per person now? (a result per person)
- What has the ballance been for every person after every transaction of his? (a result per transaction)
