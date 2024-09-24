create temporary table a_table (id integer, address text); 
insert into a_table 
values
 (1, 'Студентски Комплекс, ул. „Росарио“ 1, 1756 София'),
 (2, 'кв. Дианабад.19 Г, 1172 София'),
 (3, '4000 Пловдив Център, ул. „Иван Вазов“ 59'),
 (4, 'ж.к. Лозенец, бул. „Джеймс Баучер“ 5, 1164 София');

select	id, substring(address from '\y(\d{4})\y') as zipcode
from a_table;

select * from a_table
where address ~ 'ул\.';

select * from a_table
where address ~ '\yул\.' -- note Y vs. У 
   or address ~* '^КВ\..*ОФИЯ$';

select * 
from regexp_split_to_table('Hello regexp. power - at my fingertips!', '[, \.!+-]+') as rs; 

discard all; -- this would drop temporary objects
