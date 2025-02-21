create table ingredients(
	id serial primary key,
	name text not null
);

create table meal2ingredient(
	id serial primary key,
	ingredient_id int references ingredients(id),
	meal_id int references meals(id)
);

create table meals(
	id serial primary key,
	name text not null
);

create table meal2meal(
	id serial primary key, 
	f_meal_id int references meals(id),
	s_meal_id int references meals(id)
);

insert into ingredients (name) values ('pork'),
									  ('chicken'),
									  ('tomato'),
									  ('potato'),
									  ('cheese');

select * from ingredients;

insert into meals (name) values ('steak'),
								('fried cheese'),
								('burger');

select * from meals;

insert into meal2ingredient ( meal_id, ingredient_id) values (1 , 1), 
									  						 (2 , 5),
									  						 (3 , 4);


insert into meal2meal (f_meal_id, s_meal_id) values (3 , 2),
(3 , 1);
									  						
