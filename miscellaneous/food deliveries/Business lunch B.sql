create table product(
id integer primary key not null,
--parent_item_id integer references menu_item(id),
is_primary boolean not null default true,
name text,
other_details jsonb not null default '{}'
);

truncate table product_bridge;

create table product_bridge(
	id serial primary key not null,
	product_id integer references product(id),
	part_of_id integer references product(id),
	quantity numeric,
	other_details jsonb not null default '{}'
--constraint mip_pk primary key (item_id, product_id)
);

insert into product(id, is_primary, name)
values (0,true ,'potato'),
(1, true ,'onion'),
(2, true, 'pork'),
(10, false, 'potato salad'),
(11, false, 'porkchop'),
(12, false, 'porkpotato meal');

insert into product_bridge(product_id, part_of_id,quantity)
values (0,10, 5),
(1, 10, 1),
(2,11, 1),
(10,12,1),
(11,12,1);

with recursive cooking as 
(
	select * from product
	where id = 11
	union all
--	select add recursive part
)

