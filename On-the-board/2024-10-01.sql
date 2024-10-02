select * from about_joins.ingredient i 
join about_joins.taste t 
  on i.taste_id = t.id 
join about_joins.intensity i2 
  on i.intensity_id =i2.id;

select
	i.id, i.name as "Име", c.name as "Цвят",
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

-- Данни за ястие 
insert into about_joins.dish_recipe values (5,'таратор','Направете го внимателно', 'сервира се студен');


-- Данни за продукти и количества, bridge table recipe_ingredient 
insert into about_joins.recipe_ingredient values(5,10,1);  -- краставица
insert into about_joins.recipe_ingredient values(5,9,1);   -- кисело мляко
insert into about_joins.recipe_ingredient values(5,3,0.25,'Внимавай да не прекалиш'); -- чесън
insert into about_joins.recipe_ingredient values(5,8,30);  -- олио
insert into about_joins.recipe_ingredient values(5,4,100); -- орехи 


-- Рецептата, с връзка "много към много" чрез bridge table recipe_ingredient
select dr.name, dr.instructions, i.name, ri.quantity, u.name
from about_joins.dish_recipe dr 
join about_joins.recipe_ingredient ri
  on dr.id=ri.dish_id
join about_joins.ingredient i 
  on i.id=ri.ingredient_id 
join about_joins.unit u 
  on i.unit_id =u.id;
