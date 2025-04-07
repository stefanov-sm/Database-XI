### [Converting JSON documents to relational tables](https://www.postgresonline.com/journal/index.php?/archives/420-Converting-JSON-documents-to-relational-tables.html)
### A handy alternative approach. Demo with a 32MB JSON document file
> [!NOTE]  
> Ctrl+A and Ctrl+B are **very** unlikely to appear unescaped in a real-life data file
```sql
-- drop foreign table if exists json_data

create foreign table json_data (jsonline text)
server file_server
options (filename 'C:/foreign_data/test.json', format 'csv', delimiter e'\x01', quote e'\x02');

create table jsontable as
with t(jdata) as (
 select string_agg(jsonline, '')::jsonb
 from json_data
)
select jsonb_array_elements(jdata) j
from t;

select * from jsontable;
```
An example using `json_table` function
> [!NOTE]  
> Apply the above approach & use `json_table` for a real-life case
```sql
create temporary table the_table (js jsonb);
-- truncate table the_table;

insert into the_table values (
'{
  "favorites":[
    {
      "kind":"comedy",
      "films":[{"title":"Bananas", "director":"Woody Allen", "rating":10},
               {"title":"The Dinner Game", "director":"Francis Veber", "rating":9}]
    },
    {
      "kind":"horror",
      "films":[{"title":"Psycho", "director":"Alfred Hitchcock", "rating":8},
               {"title":"То", "director":"Стивън Кинг", "rating":8}]
    },
    {
      "kind":"thriller",
      "films":[{"title": "Vertigo", "director": "Alfred Hitchcock", "rating": 7}]
    },
    {
      "kind":"drama",
      "films":[{"title": "Yojimbo", "director": "Akira Kurosawa", "rating": 6}]
    }
  ]
}');

select * from the_table;

select jtable.* from the_table 
 cross join lateral json_table (
 	 js, '$.favorites[*]'
     columns (
 	    id for ordinality,
    	kind text path '$.kind',
     	nested path '$.films[*]'
     	columns (
     		title text path '$.title', 
     		director text path '$.director',
   			rating integer path '$.rating' 
     	)
	)
) as jtable;
