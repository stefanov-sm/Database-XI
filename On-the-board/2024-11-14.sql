-- Time - dependant (temporal) data 
create schema temporal;

create table temporal.goods (
 id serial primary key not null,
 goods_name text not null,
 price numeric
);

insert into temporal.goods (goods_name,price) values
('домати', 4.8),
('краставици', 3.5),
('олио', 3.9),
('брашно', 2.5),
('лук',1.3);

select * from temporal.goods;
select price from temporal.goods where id = 4;

create table temporal.price_temporal (
 goods_id integer references temporal.goods(id),
 valid_from date not null,
 valid_to date,
 price numeric
);

insert into temporal.price_temporal values
(4,'2024-04-14','2024-06-19', 2.5),
(4,'2024-11-11', null, 5.0); -- not known until when

-- An almost idiomatic query
-- current_date as a parameter 
select coalesce(t.price, g.price)
from temporal.goods as g 
left outer join temporal.price_temporal as t
  on g.id = t.goods_id
 -- the temporal dependancy follows  
 and current_date between 
 	valid_from and coalesce(valid_to, 'infinity')
 where g.id=4;

-- Cleanup
DROP SCHEMA temporal CASCADE;
