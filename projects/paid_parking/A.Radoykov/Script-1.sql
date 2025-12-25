create or replace function next_bussness_day(d date)
returns date
language sql
as $$
	select running_dates
	from (select d + offs as running_dates from generate_series(1, 10) as offs)
	where extract('isodow' from running_dates) between 1 and 5 
		and not exists (select 1 from nbd where nbd.nbd = running_dates)
	order by running_dates
	limit 1;
$$;
select next_bussness_day('2025-12-23'::date);

create table nbd (
	nbd date not null,
	notes text
);

insert into nbd(nbd)
values 
('2025-12-24'),
('2025-12-25');