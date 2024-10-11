-- Views, CTEs and conditional expressions

-- Using subqueries (table-valued and scalar)
select "млечни продукти", "мерна единица","цена", 
       "цена"/(select avg(price)::numeric(20,2)from public.products) as "скъпо ли е"
from (
	select * from
	(
	 select product_id, product_name as "млечни продукти", unit as "мерна единица",
	        price as "цена", category_id as "категория"
	 from (select * from public.products) as p
	 where category_id = 4
	) as daip
	join (select * from public.categories) as c on c.category_id = daip."категория"
) as q
order by "млечни продукти" desc
limit 4;

-- Using a view
create or replace view about_joins.delme_v as 
select * from
(
 select product_id, product_name as "млечни продукти", unit as "мерна единица",
        price as "цена", category_id as "категория"
 from (select * from public.products) as p
 where category_id = 4
) as daip
join (select * from public.categories) as c on c.category_id = daip."категория";

select "млечни продукти", "мерна единица","цена", 
       "цена"/(select avg(price)::numeric(20,2)from public.products) as "скъпо ли е"
from about_joins.delme_v as q
order by "млечни продукти" desc
limit 4;


-- Using CTE (non-recursive). WITH clause
with cte_t as (
	select * from
	(
	 select product_id, product_name as "млечни продукти", unit as "мерна единица",
	        price as "цена", category_id as "категория"
	 from (select * from public.products) as p
	 where category_id = 4
	) as daip
	join (select * from public.categories) as c on c.category_id = daip."категория"
),
avp(p, s) as (
	select avg(price)::numeric(20,2) as invisible, 3 as stupid from public.products
)
--select * from avp;
select "млечни продукти", "мерна единица","цена", 
       "цена"/(select p from avp) as "скъпо ли е"
from cte_t as q
order by "млечни продукти" desc
limit 4;


-- Conditional expressions (CASE)

-- Calculated CASE
SELECT CASE 
	when 3 > 4 
		then 'red' 
	when 4 > 4 
		then 'blue' 
	else 'green' 
	END;

-- Simple CASE`
SELECT CASE 3 
	when 4 
		then 'red' 
	when 5 
		then 'blue' 
	when 3 
		then 'white' 
	else 'green' 
	END;

