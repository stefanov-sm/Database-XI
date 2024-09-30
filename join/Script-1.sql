select * from ingredient;

select	i.id, i.name as "Име", c.name as "Цвят",
	cat.name as "Тип продукт", t.name as "Вкус",
	it.intensity as "Сила на вкуса", u.name as "Мярка"
from about_joins.ingredient i 
 left outer join about_joins.color as c 
              on c.id = i.color_id
 left outer join about_joins.category as cat 
              on cat.id = i.category_id 
 left outer join about_joins.taste as t 
              on t.id = i.taste_id 
 left outer join about_joins.intensity as it 
              on it.id = i.intensity_id 
 left outer join about_joins.unit as u 
              on u.id = i.unit_id;
