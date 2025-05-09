-- Create a query on "test_table" below that yields 3 columns: vdate, value and ballance for each day for the last two months

create table if not exists test_table 
(
  id integer primary key not null generated by default as identity,
  vdate date not null, -- value date
  value numeric not null, -- deposit/withdrawal
  details jsonb not null default '{}'
);

insert into test_table (value, details, vdate)
values (1000, '{"status":"inititial ballance"}', current_date - 60);

insert into test_table (vdate, value)
select current_date - random (1, 59) as vdate, random (-100, 100) as value
from generate_series(1, 20);

select * from test_table;

-- TODO: 
--  write a query that yields 3 columns: 
--  vdate, value and ballance
--  for EACH of the last 60 days

-- cleanup when done
drop table if exists test_table;
