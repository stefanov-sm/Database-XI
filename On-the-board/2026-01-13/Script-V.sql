select '[{
"name": "Draganina",
"birthYear": 20144,
"sex": false
},

{
"name": "Pesho",
"birthYear": 2005,
"sex": true
},

{
"name": "Draganka",
"birthYear": 641,
"sex": false
}]':: json -> 1 ->> 'birthYear';

drop table if exists;
create temporary table jsontest( id serial, details jsonb );
insert into jsontest(details) values ('[{
"name": "Dragan",
"birthYear": 2014,
"sex": false
},

{
"name": "Pesho",
"birthYear": 2005,
"sex": true
},

{
"name": "Draganka",
"birthYear": 641,
"sex": false
}]');

with t as (select * from jsontest cross join lateral jsonb_array_elements (details) as t (jde))
select id, jde ->> 'name' as name, jde ->> 'birthYear'as birth_year, jde ->> 'sex' as sex from t;

