insert into ingredient (id, "name", category_id, color_id, taste_id, intensity_id, unit_id)
values
 (1, 'домат', 1, 10, 3, 2, 1),
 (2, 'лук', 1, 15, 5, 2, 1),
 (3, 'чесън', 1, 17, 5, 3, 1),
 (4, 'орех', 91, 19, 6, 92, 2);

select
	i.id, i.name as "Име", c.name as "Цвят",
	cat.name as "Тип продукт", t.name as "Вкус",
	it.intensity as "Сила на вкуса", u.name as "Мярка"
from ingredient i 
 left outer join color as c 
              on c.id = i.color_id
 left outer join category as cat 
              on cat.id = i.category_id 
 left outer join taste as t 
              on t.id = i.taste_id 
 left outer join intensity as it 
              on it.id = i.intensity_id 
 left outer join unit as u 
              on u.id = i.unit_id;