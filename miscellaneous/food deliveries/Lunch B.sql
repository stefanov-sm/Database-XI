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
	select *, 2::numeric as "quantity" from product
	where id = 12
	union ALL
	
	select p.*, c.quantity * pb.quantity from product p, product_bridge pb
		join cooking c on c.id = pb.part_of_id
		where p.id = pb.product_id
		
--	select add recursive part
)

select * FROM cooking;

insert into product(id, is_primary, name)
values (3, true, 'cheese'),
(13, false, 'cheesy pork')
