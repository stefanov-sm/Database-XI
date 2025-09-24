create table bigtablea
(
 id serial primary key not null,
 value numeric,
 roman text
);

insert into bigtablea (value, roman)
select (random() * 100000)::numeric(10, 2),
       to_char((random() * 3000)::integer, 'FMRN')
from generate_series(1, 10000000, 1) as s;

select * from bigtablea;

create table bigtableb as select * from bigtablea;

-- Create discrepancies
update bigtablea set value = 7301.39,  roman = 'MXMII' where id = 10;
update bigtablea set value = 79320.19, roman = 'XIMLC' where id = 15;
update bigtablea set value = 23150.07, roman = 'CILXM' where id = 350;
update bigtableb set value = 41223.60, roman = 'ILMCC' where id = 1001;
update bigtableb set value = 86201.90, roman = 'MXMII' where id = 2001;
update bigtableb set value = 85710.00, roman = 'CCXMX' where id = 2090;

-- Find discrepancies
select * from (
  (
    select *, 'tableA' as "comes from" from bigtablea  
    except all
    select *, 'tableA' as "comes from" from bigtableb
  ) 
  union all
  (
    select *, 'tableB' as "comes from" from bigtableb 
    except all
    select *, 'tableB' as "comes from" from bigtablea
  )
)
order by id, "comes from";
