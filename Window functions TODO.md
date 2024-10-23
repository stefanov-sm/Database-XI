## Window functions TODO
> [!IMPORTANT]  
> Before you proceed, read the reference [here](https://www.postgresql.org/docs/current/tutorial-window.html#TUTORIAL-WINDOW).  
> Pay special attention to window frame definition [here](https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS)  
> and important built-in functions [here](https://www.postgresql.org/docs/current/functions-window.html#FUNCTIONS-WINDOW).

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
![image](https://github.com/user-attachments/assets/ed2be3c8-8af4-432d-95ab-084f2b9824c4)

- What is the ballance per person now? (a result per person)
- What has the ballance been for every person after every transaction of his? (a result per transaction)
