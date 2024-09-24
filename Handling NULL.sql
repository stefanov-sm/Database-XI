create temporary table a_table (id integer, address text); 
insert into a_table 
values
 (1, 'Студентски Комплекс, ул. „Росарио“ 1, 1756 София'),
 (2, 'кв. Дианабад.19 Г, 1172 София'),
 (3, '4000 Пловдив Център, ул. „Иван Вазов“ 59'),
 (4, 'ж.к. Лозенец, бул. „Джеймс Баучер“ 5, 1164 София'),
 (5, 'nowhere'),
 (6, null);

/*
 * My empyrical mnemonic rule:
 * Say "don't know" instead of "null" so that your common sense logic works correctly
 * An expression with NULL in it returns NULL.
 * except TRUE OR NULL and FALSE AND NULL 
*/

select 12 + null, 33 * 2 / null, 
	false or null, true and null, 
	true or null, false and null;


-- Use of IS NULL and IS NOT NULL unary postfix operators 
select	id, address from a_table 
where address is null;

/*
 * using the IS NULL operator returns the correct result
 * using the equality check operator (=) WHERE ADDRESS = NULL returns no results 
 * Comparison operators do not work properly with NULL.
 * IS DISTINCT FROM / IS NOT DISTINCT FROM operators work correctly with NULL.  
 *
 * Beware: Opposite expressions yield the same result
*/

select id, 
	address > 'к' as res_a,
	NOT address > 'к' as res_b
from a_table;

select id, 
	coalesce((address > 'к'), false) as res_a,
	coalesce(NOT (address > 'к'), false) as res_b
from a_table; 


-- Use of COALESCE and NULLIF 
select id, coalesce(address, '*** Безмислени данни ***') as address from a_table; 
select id, nullif(address, 'nowhere') as address from a_table; 

discard all; -- this would drop temporary objects