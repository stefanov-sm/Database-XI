-- Extract-Transform-Load (ETL) and ELT

/* Fixed width field format 
123456ABCDV123ABCDEF1234567890AНякакъв текст А
223456ABCDW223abcdef1234567890AДруг текст Б
323456ABCDX323ABCDEF1234567890AНякакъв текст В
423456ABCDY423abcdef1234567890AДруг текст Г
523456ABCDZ523ABCDEF1234567890AНякакъв текст Д
*/

-- Data extraction using COPY command
create temporary table fw_tbl(fl text);
copy fw_tbl from 'C:\foreign_data\fl_data.txt'
with (format 'csv', delimiter E'\b', encoding 'Windows-1251');

-- using a foreign table
create foreign table fw_ftbl (fl text)
server file_server
options 
(
  filename 'C:\foreign_data\fl_data.txt',
  format 'csv', delimiter E'\b', encoding 'Windows-1251'
);

select * from fw_tbl;
select * from fw_ftbl;

/* or using INSERT
insert into fw_tbl 
values ('123456ABCDZ123ABCDEF1234567890AНякакъв текст А'), ('223456ABCDZ123ABCDEF1234567890AДруг текст Б'),
       ('323456ABCDZ123ABCDEF1234567890AНякакъв текст В'), ('423456ABCDZ123ABCDEF1234567890AДруг текст Г'),
       ('523456ABCDZ123ABCDEF1234567890AНякакъв текст Д');
*/


-- drop function if exists fw_regexp;
--------------------------------------------------------------------------------
create or replace function fw_regexp(pos_list text)
returns text language sql immutable as 
$$
 select '^'
    || string_agg(coalesce('(.{'||len||'})', '(.*)'), null order by pos)
    || '$'
 from
 (
  select pos, lead(pos) over (order by pos) - pos as len
  from unnest(string_to_array(pos_list, ',')::integer[]) as t(pos)
 ) as t;
$$;

-- Unit test
select fw_regexp('1,7,12,15,11,32,21');

-- drop function if exists fw_array;
--------------------------------------------------------------------------------
create or replace function fw_array(fwdata text, fwregexp text)
returns text[] language sql immutable as 
$$
  select regexp_match(fwdata, fwregexp);
$$;


/* Two more things to be defined:
 - the fields' start offsets, i.e. 1,7,12,15,11,32,21 in this example,
   an easy thing to do with a text editor
 - the column names and data types
*/
-- data transformation in the SELECT expression list
-- data cleansing in the WHERE clause
create or replace temporary view fw_view as
select  arr[1]::numeric as apple, arr[2] as pear,   arr[3] as peach,
        arr[4]::integer as lemon, arr[5] as orange, arr[6] as plum,
        arr[7] as cherry 
from
(
 select fw_array(fl, fw_regexp('1,7,12,15,11,32,21')) as arr
 from fw_ftbl
) as t
where not arr[7] ~* 'друг';

select * from fw_view;

discard all;
