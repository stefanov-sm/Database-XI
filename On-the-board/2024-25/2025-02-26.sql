-- forex_long() version w/o the use of JSON reflection
-- using the system catalog and an implicit cursor loop
create or replace function forex_long()
returns table (currency text, currency_date date, value numeric) language plpgsql stable as
$$
declare
	currency text;
	DYNSQL_TEMPLATE constant text := 'SELECT %1$L, "Date", %1$s FROM ecb_forex';
begin
  for currency in 
    select column_name from information_schema."columns" c 
    where table_schema = 'public' 
      and table_name = 'ecb_forex' 
      and c.column_name not in ('Date', 'dummy')
  loop 
    return query 
      execute format(DYNSQL_TEMPLATE, currency) using currency;
  end loop;
end;
$$;

-- version of the foreign table with all row data in a single column
-- tolerant to damaged data files
-- note the BACKSPACE (E'\b') delimiter
create foreign table ecb_forexd 
(
 rec text
)
server file_server
options (
 filename 'C:/foreign_data/eurofxref-hist.csv',
 format 'csv', delimiter E'\b', null 'N/A', header 'true'
);

-- version of the unpivot function that works with table ecb_forexd
-- note the unnest function with two arguments and the array slice, row_array[2:]
create or replace function thin_out_table()
returns table(currency text, "Date" date, value numeric) language plpgsql as
$$
declare
  r text;
  row_array text[];
  columns_list text[] := (select array_agg(column_name)
                          from information_schema.columns 
                          where table_name  = 'ecb_forex'
	                    and table_schema = 'public'
                            and column_name not in ('Date', 'dummy'));
begin
  for r in select rec from ecb_forexd loop
    row_array := string_to_array(r, ',');
    return query 
      select curr, row_array[1]::date, NULLIF(NULLIF(rate, 'N/A'), '')::numeric
      from unnest(columns_list, row_array[2:]) as t(curr, rate)
      where curr is not null and rate is not null;
  end loop;
end;
$$;
