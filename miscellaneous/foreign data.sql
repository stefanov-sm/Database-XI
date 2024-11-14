create extension file_fdw;
create server file_server foreign data wrapper file_fdw;

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
options
(
 filename 'C:/foreign_data/eurofxref-hist.csv',
 format 'csv', delimiter ',', null 'N/A', header 'true'
);

select "Date", try 
from ecb_forex 
where try is not null
order by "Date";