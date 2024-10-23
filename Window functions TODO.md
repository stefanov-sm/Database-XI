## Window functions TODO
> [!IMPORTANT]  
> Before you proceed, read the reference [here](https://www.postgresql.org/docs/current/tutorial-window.html#TUTORIAL-WINDOW).  
> Pay special attention to window frame definition [here](https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS)  
> and important built-in functions [here](https://www.postgresql.org/docs/current/functions-window.html#FUNCTIONS-WINDOW).
>   
> You may also have a look at `generate_series` [here](https://www.postgresql.org/docs/current/functions-srf.html#FUNCTIONS-SRF)

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

-- Populate the tables

insert into person (name) values ('Георги'), ('Петър'), ('Мария');
insert into initial_ballance (person_id, ballance) values (1, 100), (2, 150), (3, 200);

insert into transaction (person_id, transaction_date, value)
with t as (select generate_series(1, 100, 1)), -- just 100 rows
     p as (select id as pid from person)       -- list of person id-s
select 
    pid, 
    '2020-01-01'::date +  (random() * (current_date - '2020-01-01'))::integer, 
    (random() * 100 - 50)::numeric(10, 2)
from t cross join p; -- all persons for each row of CTE t
```
![image](https://github.com/user-attachments/assets/ed2be3c8-8af4-432d-95ab-084f2b9824c4)

## To do
#### A simplified - yet realistic - bank account statement
- What is the ballance per person now? (a result per person)
- What has the ballance been for every person after every transaction of his? (a result per transaction, may filter by `person_id`)
- an extra requirement with a smile - _present_ the integer part of transaction values in a separate column as roman numerals (ex. `47.39` becomes `XLVII`, `-19` becomes `sine XIX`)
