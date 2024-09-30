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
select * from about_joins.color;

insert into about_joins.taste
values
 (1, 'сладък'),
 (2, 'солен'),
 (3, 'кисел'),
 (4, 'горчив'),
 (5, 'лют'),
 (6, 'неутрален');
select * from about_joins.taste; 

insert into about_joins.intensity
values
 (1, 'много слабо'),
 (2, 'слабо'),
 (3, 'умерено'),
 (4, 'силно'),
 (5, 'много силно'),
 (6, 'екстремално');
select * from about_joins.intensity; 

insert into about_joins.category
values 
 (1, 'зеленчуци'),
 (2, 'плодове'),
 (3, 'месо'),
 (4, 'риба и морски дарове'),
 (5, 'варива'),
 (6, 'тестени и паста'),
 (7, 'подправки');
select * from about_joins.category;

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
select * from about_joins.unit;
