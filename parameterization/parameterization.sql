-- ---------------------------------------------------------------------
create or replace function par.in_range_list(target numeric, arg_range_list text)
returns boolean language sql immutable as $function$
-- Valid range list syntax: 'NULL' or '1' or '1,2,3' or '1,2..5,7..23,100'
select (arg_range_list is null)
or exists
(
  select from unnest(string_to_array(arg_range_list, ',')) as r 
  where case
    when r !~ '\.\.' then (target = r::numeric)  -- single value
    else (target between split_part(r, '..', 1)::numeric 
                     and split_part(r, '..', 2)::numeric)
  end
)
$function$;
-- ---------------------------------------------------------------------
create table if not exists par.item
(
 id serial primary key not null,
 name text,
 category integer check (category in (1, 2, 3, 4)), -- тип: (1) плод, (2) зеленчук, (3) вариво, (4) друго
 shelf_life integer check (shelf_life in (1, 2, 3)) -- трайност: (1) малка, (2) средна, (3) голяма
);
-- ---------------------------------------------------------------------
create table if not exists par.sales
(
 id serial primary key not null,
 item_id integer references par.item(id),
 sales_date date,
 quantity numeric
);
-- ---------------------------------------------------------------------
create table if not exists par.param
(
 id serial primary key not null,
 description_a text,
 code_a text,
 description_b text,
 code_b text,
 notes text
);
-- ---------------------------------------------------------------------
insert into par.item (name, category, shelf_life)
values
 ('ябълка', 1, 2),       ('круша', 1, 2),         ('портокал', 1, 2),    ('мандарина', 1, 2),
 ('банан', 1, 1),        ('нар', 1, 2),           ('диня', 1, 2),        ('пъпеш', 1, 2),
 ('ягода', 1, 1),        ('череша', 1, 1),        ('слива', 1, 2),       ('кокосов орех', 1, 3),
 ('дюля', 1, 2),         ('тиква', 1, 2),         ('грозде', 1, 2),      ('орех', 4, 3),
 ('фастък', 4, 3),       ('лешник', 4, 3),        ('зелен лук', 2, 1),   ('зелен чесън', 2, 1),
 ('маруля', 2, 1),       ('магданоз', 2, 1),      ('копър', 2, 1),       ('стар лук', 2, 3),
 ('стар чесън', 2, 3),   ('краставица', 2, 2),    ('тиквичка', 2, 2),    ('патладжан', 2, 2),
 ('домат', 2, 2),        ('спанак', 2, 1),        ('зелен фасул', 2, 2), ('грах', 2, 2),
 ('зелена чушка', 2, 2), ('червена чушка', 2, 2), ('сушена чушка', 2, 3),
 ('боб', 3, 3),          ('леща', 3, 3);
-- ---------------------------------------------------------------------
insert into par.param (description_a,code_a,description_b,code_b,notes) values
 ('category', '2',   'shelf_life', '2',   '3.Зеленчуци със средна трайност'),
 ('category', '2',   'shelf_life', '1',   '1.Зеленчуци с малка трайност'),
 ('category', '3',   'shelf_life', '3',   '5.Варива с голяма трайност'),
 ('category', '1',   'shelf_life', '1',   '2.Плодове с малка трайност'),
 ('category', '4',   'shelf_life', '3',   '6.Други с голяма трайност'),
 ('category', '3,4', 'shelf_life', NULL,  '7.Разни други'),
 ('category', '1,2', 'shelf_life', NULL,  '8.Плодове и зеленчуци'),
 ('category', '1',   'shelf_life', '2,3', '4.Плодове със средна и голяма трайност'),
 ('category', NULL,  'shelf_life', '1',   '9.Всички с малка трайност');
-- ---------------------------------------------------------------------
select id, name "име", 
 (array['плод','зеленчук','вариво','друго'])[category] "тип",
 (array['малка','средна','голяма'])[shelf_life] "трайност"
from par.item;
-- ---------------------------------------------------------------------
truncate table par.sales;
insert into par.sales (item_id, sales_date, quantity)
 select random(1, 37), '2025-05-01'::date + random(1, 61), random(1, 100)::numeric / 20
 from generate_series (1, 500000);
-- ---------------------------------------------------------------------
select sales.id, sales_date "дата", quantity "количество", name "име", category,
       (array['плод','зеленчук','вариво','друго'])[category] "тип",
       (array['малка','средна','голяма'])[shelf_life] "трайност"
from par.sales
join par.item on item_id = item.id;

-- ---------------------------------------------------------------------
-- Here it is - a complex report made flexible and simple
-- ---------------------------------------------------------------------
select param.notes, count(*), sum(quantity)
from par.sales join par.item on sales.item_id = item.id

join par.param on 
     par.in_range_list(category,   param.code_a)
 and par.in_range_list(shelf_life, param.code_b)

 where sales_date between '2025-05-01' and '2025-05-31'
group by param.id
order by substring(notes from '^\d+')::numeric;

/*
notes                                 |count |sum      |
--------------------------------------+------+---------+
1.Зеленчуци с малка трайност          | 39836|100685.25|
2.Плодове с малка трайност            | 19861| 50051.05|
3.Зеленчуци със средна трайност       | 53069|133674.35|
4.Плодове със средна и голяма трайност| 80066|202363.65|
5.Варива с голяма трайност            | 13135| 33226.25|
6.Други с голяма трайност             | 19954| 50597.75|
7.Разни други                         | 33089| 83824.00|
8.Плодове и зеленчуци                 |212447|536535.55|
9.Всички с малка трайност             | 59697|150736.30|

insert into par.param (description_a,code_a,description_b,code_b,notes)
values
 ('category', null, 'shelf_life', null, '10. Всичко продадено');

*/

