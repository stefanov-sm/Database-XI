### [Converting JSON documents to relational tables](https://www.postgresonline.com/journal/index.php?/archives/420-Converting-JSON-documents-to-relational-tables.html)
### A handy alternative approach. Demo with a 32MB JSON document file
>  [!IMPORTANT]  
> Ctrl+A and Ctrl+B are **very** unlikely to appear unescaped in a real-life data file
```sql
-- drop foreign table if exists json_data

create foreign table json_data (jsonline text)
server file_server
options (filename 'C:/foreign_data/test.json', format 'csv', delimiter e'\x01', quote e'\x02');

create table json_table as
with t(jdata) as (
 select string_agg(jsonline, '')::jsonb
 from json_data
)
select jsonb_array_elements(jdata) j
from t;

select * from json_table;
```
