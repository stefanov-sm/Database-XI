-- 3.5
select * from categories c;
select category_id, category_name from categories c

where category_name = 'Seafood' or description = 'Cheeses';
select * from customers c2;

select customer_name as "Name", 'the city of ' || city as "Борислава" from customers c2
where country = 'USA' order by "Борислава" desc, "Name" desc;

select country, count (*) as cnt from customers c group by country order by cnt desc;
select * from products p;

select product_name, price / 1.956 as "Price in EUR" from products p 
where price > 100;
 

-- 4.1
select * from categories;
select 'Food class: ' || category_name as "Name ""as is"" !", description from categories
where category_name = 'Seafood';

select * from customers;
select customer_name, 'City of ' || city as "City",'Resident of: '|| country as "Residence" 
from customers
where country = 'USA'
order by city desc, customer_name desc;

select * from products
where price >= 20;

select * -- products.product_name, products.unit, products.price, categories.category_name, categories.description 
from products
join categories on products.category_id = categories.category_id;


-- 3.4
select *,customer_name,'the city of ' || city as "City ""as is""" 
from customers 
where country = 'USA' 
order by "City ""as is""", customer_name ;

update customers set postal_code = '999999', address = null 
where city = 'Portland';

select * from customers 
where address is null;

begin transaction;

delete from customers 
where address is null;

rollback;
commit;