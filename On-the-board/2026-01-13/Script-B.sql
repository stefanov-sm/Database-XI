select '{
	"number": 15,
	"text": "Hello, world!\n",
	"boolean": true,
	"arr1": [
		1,2,3,4,5
	],
	"obj": {
		"is Null": null
	}
}'::json;

create temporary table json_table (
	id serial,
	details jsonb
);

insert into json_table ( details) values (
'{
	"number": 35,
	"text": "Humpty dumpty sat on a wall",
	"boolean": false,
	"arr1": [
		11, 12, 13, 67
	],
	"obj": {
		"is Null": true
	}
}'
);


select * from json_table;


with t as (
select id, (details ->> 'number')::integer "number", details ->> 'text' "text", 
(details -> 'obj' ->> 'is Null')::boolean "boolean" , ael::integer  from  json_table
cross join lateral jsonb_array_elements(details -> 'arr1') as t(ael)
) select * from t;



create temporary table json_args (
	number integer,
	text text,
	boolean boolean,
	number1 integer,
	is_null boolean
);

insert into json_args (number , text, boolean, number1, is_null)
select * from json_table
