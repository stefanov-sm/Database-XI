-- The extension binary is a part of the distribution pack
create extension file_fdw;
create server file_server foreign data wrapper file_fdw;

-- Attach file eurofxref-hist.csv (ECB exchange rate history) as a foreign table
-- https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist.zip
-- Fields' list is taken from the CSV file's header
-- Note the trailing dummy field because of the trailing commas in the CSV file
create foreign table ecb_forex
(
 "Date" date,
 USD numeric, JPY numeric, BGN numeric, CYP numeric, CZK numeric, DKK numeric, EEK numeric,
 GBP numeric, HUF numeric, LTL numeric, LVL numeric, MTL numeric, PLN numeric, ROL numeric,
 RON numeric, SEK numeric, SIT numeric, SKK numeric, CHF numeric, ISK numeric, NOK numeric,
 HRK numeric, RUB numeric, TRL numeric, TRY numeric, AUD numeric, BRL numeric, CAD numeric,
 CNY numeric, HKD numeric, IDR numeric, ILS numeric, INR numeric, KRW numeric, MXN numeric,
 MYR numeric, NZD numeric, PHP numeric, SGD numeric, THB numeric, ZAR numeric, dummy text
)
server file_server
options (
 filename 'C:/foreign_data/eurofxref-hist.csv',
 format 'csv', delimiter ',', null 'N/A', header 'true'
);

select * from ecb_forex;

-- Min and max rating of the turkish lira
select * from (select 'try' as currency, "Date", try from ecb_forex order by try limit 1) 
union all
select * from (select 'try' as currency, "Date", try from ecb_forex order by try desc nulls last limit 1);

-- Min and max rating of the turkish lira and swiss frank using window functions
select	first_value("Date") over (order by try), first_value(try) over (order by try),
		first_value("Date") over (order by try desc nulls last), first_value(try) over (order by try desc nulls last),
		first_value("Date") over (order by chf), first_value(chf) over (order by chf),
		first_value("Date") over (order by chf desc nulls last), first_value(chf) over (order by chf desc nulls last)
from ecb_forex limit 1;

-- Unpivot the table into a "thin" one (currency text, currency_date date, value numeric)
create or replace function forex_long()
returns table (currency text, currency_date date, value numeric) language plpgsql stable as
$$
declare
	currency_list text[];
	jsonstruct json;
	currency text;
	DYNSQL_TEMPLATE constant text := 'SELECT %1$L, "Date", %1$s FROM ecb_forex';
begin
  -- extract the list of columns (reflection-like operation using JSON)
  jsonstruct := (select to_json(ef) from ecb_forex ef limit 1);
	currency_list := (
                    select array_agg(j) from json_object_keys(jsonstruct) as j 
                    where j not in ('Date', 'dummy')
                   );
  -- extract data per currency using dynamic SQL
  foreach currency in array currency_list loop
	  return query 
		  execute format(DYNSQL_TEMPLATE, currency) using currency;
	end loop;
end;
$$;

select * from forex_long() order by currency;

-- create a "real" table with a stable structure that can be indexed
create table ecb_forex_thin as select * from forex_long();
alter table ecb_forex_thin add constraint ecb_forex_thin_pk primary key (currency, currency_date);
