----------------------------------------------------------------------------------- 
-- JSON generating queries
----------------------------------------------------------------------------------- 

CREATE TEMPORARY TABLE actions (
    action_time timestamp without time zone,
    user_id integer
);

INSERT INTO actions (action_time, user_id) VALUES
('2015-01-20 01:00:00',	1),
('2015-01-01 01:00:00',	1),
('2015-01-10 01:00:00',	1),
('2015-01-12 01:00:00',	1),
('2015-01-16 01:00:00',	1),
('2015-01-23 01:00:00',	1),
('2015-02-20 01:00:00',	1),
('2015-03-20 01:00:00',	1),
('2015-05-20 01:00:00',	1),
('2015-06-20 01:00:00',	1),
('2015-01-20 01:00:00',	2),
('2015-03-20 01:00:00',	2),
('2015-04-20 01:00:00',	2),
('2015-05-20 01:00:00',	2),
('2015-05-21 01:00:00',	2),
('2015-05-21 01:00:00',	2),
('2015-05-23 01:00:00',	2);

----------------------------------------------------------------------------------- 
-- table-returning query
select json_agg(to_json(t)) from (

	-- the table-returning query here with no trainling semicolon
	select action_time, substr(random()::text,3,7) as action_rndm from actions where user_id = 2

) as t;

----------------------------------------------------------------------------------- 
-- scalar query
select json_build_object('value', (

	-- the scalar query here with no trainling semicolon

	select max(action_time) from actions where user_id = 2

));

----------------------------------------------------------------------------------- 
-- table-returning query in a CTE
with t as (

	-- the table-returning query here with no trainling semicolon

	select action_time, substr(random()::text,3,7) as action_rndm 
	from actions 
	where user_id = 2

)
select json_agg(to_json(t)) from t;

----------------------------------------------------------------------------------- 
-- table-returning DML query in a data modifying CTE
with t as (

	-- the table-returning DML query (using RETURNING)
	insert into actions (action_time, user_id)
		select clock_timestamp(), 5 from generate_series(1, 10)
	RETURNING to_char(action_time, 'yyyy-mm-dd hh24:mi:ss.us') as action_time

)
select json_agg(to_json(t)) from t;


----------------------------------------------------------------------------------- 
-- JSON flattening to regular tables
----------------------------------------------------------------------------------- 

create temporary table a_table (id integer, jsondata jsonb);
insert into a_table values
 (1, '{"List":[{"One": 1, "Two": true, "Three": "3"}, {"One": 11, "Two": false, "Three": "13", "Four": {"Five": 5}}, {"One": 21, "Two": null, "Three": "23"}]}'::jsonb),
 (2, '{"List":[{"One": 101, "Two": true, "Three": "103"}, {"One": 1011, "Two": false, "Three": "1013"}, {"One": 1021, "Two": null, "Three": "1023"}]}'),
 (3, '{"List":[{"One": 201, "Two": true, "Three": "203"}, {"One": 2011, "Two": false, "Three": "2013"}, {"One": 2021, "Two": true, "Three": "2023"}]}');

create temporary table b_table (id integer, jsondata jsonb);
insert into b_table values 
 (1, '{"One": 1, "Two": true, "Three": "3"}'::jsonb),
 (2, '{"One": 1011, "Two": false, "Three": "1013", "Four": {"Five": 5}}'),
 (3, '{"One": 0, "Four": 4}');

----------------------------------------------------------------------------------- 

select id,
 (j['One'])::text one,
 (j->>'Two')::boolean two,
 (j->>'Three')::integer three,
 (j->'Four'->>'Five')::integer four
from a_table,
lateral jsonb_array_elements(jsondata->'List') as j;

----------------------------------------------------------------------------------- 

select id, "One", "Two", "Three", ("Four"->>'Five')::integer four
from a_table,
lateral jsonb_to_recordset(jsondata->'List') 
 as j ("One" text, "Two" boolean, "Three" integer, "Four" jsonb);

----------------------------------------------------------------------------------- 

select id, 
 (jsondata->>'One') one, 
 (jsondata->>'Two')::boolean two, 
 (jsondata->>'Three')::integer three, 
 (jsondata->'Four'->>'Five')::integer four
from b_table;     

----------------------------------------------------------------------------------- 

discard all;