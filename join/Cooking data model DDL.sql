create schema if not exists about_joins;

create table about_joins.color (id integer primary key, name text, color_attr integer);          
create table about_joins.taste (id integer primary key, name text);
create table about_joins.intensity (id integer primary key, intensity text);
create table about_joins.category (id integer primary key, name text);
create table about_joins.unit (id integer primary key, name text);
create table about_joins.ingredient (id integer primary key, name text, category_id integer, color_id integer, taste_id integer, intensity_id integer, unit_id integer);
create table about_joins.dish_recipe (id integer primary key, name text, instructions text, notes text);
create table about_joins.recipe_ingredient (dish_id integer, ingredient_id integer, quantity numeric, notes text, primary key (dish_id, ingredient_id));

insert into about_joins.color 
values
 (10, 'червен', 1000),
 (11, 'зелен', 2000),
 (12, 'син', 3000),
 (13, 'циан', 4000),
 (14, 'магента', 5000),
 (15, 'жълт', 6000),
 (16, 'черен', 7000),
 (17, 'бял', 8000),
 (18, 'оранжев', 9000),
 (19, 'кафяв', 10000),
 (20, 'розов', 11000),
 (21, 'виолетов', 12000);

insert into about_joins.taste
values
 (1, 'сладък'),
 (2, 'солен'),
 (3, 'кисел'),
 (4, 'горчив'),
 (5, 'лют'),
 (6, 'неутрален');

insert into about_joins.intensity
values
 (1, 'много слабо'),
 (2, 'слабо'),
 (3, 'умерено'),
 (4, 'силно'),
 (5, 'много силно'),
 (6, 'екстремално');

insert into about_joins.category
values 
 (1, 'зеленчуци'),
 (2, 'плодове'),
 (3, 'месо и колбаси'),
 (4, 'риба и морски дарове'),
 (5, 'варива'),
 (6, 'тестени и паста'),
 (7, 'подправки'),
 (8, 'мляко и млечни продукти'),
 (9, 'ядки'),
 (10, 'други');

insert into about_joins.unit
values 
 (1, 'брой'),
 (2, 'грам'),
 (3, 'литър'),
 (4, 'пакетче (както в "пакетче бакпулвер")'), 
 (5, 'кофичка (както в "кофичка кисело мляко")'),
 (6, 'чаена лъжичка (както в "чаена лъжичка червен пипер")'), 
 (7, 'кафена лъжичка (както в "кафена лъжичка захар")'), 
 (8, 'щипка (както в "щипка сол")'); 

insert into about_joins.ingredient (id, "name", category_id, color_id, taste_id, intensity_id, unit_id)
values
 (1, 'домат', 1, 10, 3, 2, 1),
 (2, 'лук', 1, 15, 5, 2, 1),
 (3, 'чесън', 1, 17, 5, 3, 1),
 (4, 'орех', 91, 19, 6, 92, 2),
 (5, 'черен пипер', 7, 16, 5, 4, 2),
 (6, 'яйце', null, 17, 6, null, 1),
 (7, 'кайма', 3, 10, null, null, 2),
 (8, 'олио', null, 15, null, null, 2),
 (9, 'кисело мляко', 8, 17, 3, 2, 5),
 (10, 'краставица', 1, 11, 3, 1, 1);

------------------------------------------------------------------------

select * from about_joins.color;
select * from about_joins.taste; 
select * from about_joins.intensity; 
select * from about_joins.category;
select * from about_joins.unit;
select * from about_joins.ingredient;
