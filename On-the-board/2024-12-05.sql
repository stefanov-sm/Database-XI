-- drop table if exists public.iban_sizes;
create table public.iban_sizes (
 country_abbrev text primary key,
 iban_size integer check (iban_size between 10 and 50),
 notes text 
 );
insert into public.iban_sizes (iban_size, country_abbrev, notes) values
('28', 'AL', 'Albania'),('24', 'AD', 'Andorra'),('20', 'AT', 'Austria'),('28', 'AZ', 'Azerbaijan'),('22', 'BH', 'Bahrain'),
('28', 'BY', 'Belarus'),('16', 'BE', 'Belgium'),('20', 'BA', 'Bosnia and Herzegovina'),('29', 'BR', 'Brazil'),('22', 'BG', 'Bulgaria'),
('27', 'BI', 'Burundi'),('22', 'CR', 'Costa Rica'),('21', 'HR', 'Croatia'),('28', 'CY', 'Cyprus'),('24', 'CZ', 'Czech Republic'),
('18', 'DK', 'Denmark'),('27', 'DJ', 'Djibouti'),('28', 'DO', 'Dominican Republic'),('23', 'TL', 'East Timor'),('29', 'EG', 'Egypt'),
('28', 'SV', 'El Salvador'),('20', 'EE', 'Estonia'),('18', 'FK', 'Falkland Islands'),('18', 'FO', 'Faroe Islands'),('18', 'FI', 'Finland'),
('27', 'FR', 'France'),('22', 'GE', 'Georgia'),('22', 'DE', 'Germany'),('23', 'GI', 'Gibraltar'),('27', 'GR', 'Greece'),
('18', 'GL', 'Greenland'),('28', 'GT', 'Guatemala'),('28', 'HU', 'Hungary'),('26', 'IS', 'Iceland'),('23', 'IQ', 'Iraq'),
('22', 'IE', 'Ireland'),('23', 'IL', 'Israel'),('27', 'IT', 'Italy'),('30', 'JO', 'Jordan'),('20', 'KZ', 'Kazakhstan'),
('20', 'XK', 'Kosovo'),('30', 'KW', 'Kuwait'),('21', 'LV', 'Latvia'),('28', 'LB', 'Lebanon'),('25', 'LY', 'Libya'),
('21', 'LI', 'Liechtenstein'),('20', 'LT', 'Lithuania'),('20', 'LU', 'Luxembourg'),('31', 'MT', 'Malta'),('27', 'MR', 'Mauritania'),
('30', 'MU', 'Mauritius'),('27', 'MC', 'Monaco'),('24', 'MD', 'Moldova'),('20', 'MN', 'Mongolia'),('22', 'ME', 'Montenegro'),
('18', 'NL', 'Netherlands'),('28', 'NI', 'Nicaragua'),('19', 'MK', 'North Macedonia'),('15', 'NO', 'Norway'),('23', 'OM', 'Oman'),
('24', 'PK', 'Pakistan'),('29', 'PS', 'Palestinian territories'),('28', 'PL', 'Poland'),('25', 'PT', 'Portugal'),('29', 'QA', 'Qatar'),
('24', 'RO', 'Romania'),('33', 'RU', 'Russia'),('32', 'LC', 'Saint Lucia'),('27', 'SM', 'San Marino'),('25', 'ST', 'Sao Tome and Principe'),
('24', 'SA', 'Saudi Arabia'),('22', 'RS', 'Serbia'),('31', 'SC', 'Seychelles'),('24', 'SK', 'Slovakia'),('19', 'SI', 'Slovenia'),
('23', 'SO', 'Somalia'),('24', 'ES', 'Spain'),('18', 'SD', 'Sudan'),('24', 'SE', 'Sweden'),('21', 'CH', 'Switzerland'),
('24', 'TN', 'Tunisia'),('26', 'TR', 'Turkey'),('29', 'UA', 'Ukraine'),('23', 'AE', 'United Arab Emirates'),('22', 'GB', 'United Kingdom'),
('22', 'VA', 'Vatican City'),('24', 'VG', 'Virgin Islands, British'),('30', 'YE', 'Yemen');
select * from public.iban_sizes;

-- Клас Б
create or replace function public.iban_check (arg_iban text)
returns boolean language plpgsql immutable as 
$$
declare 
	country_id text;
	iban_arr text[];
	letters text[] := '{A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z}';
begin
	arg_iban := regexp_replace(upper(arg_iban), '[^A-Z0-9]', '', 'g');
	country_id := substr(arg_iban, 1, 2);
	if not exists  (
			 select from public.iban_sizes 
			 where country_abbrev = country_id
			 and length(arg_iban) = iban_size
			) then 
		return false;
	end if;
	arg_iban := substr(arg_iban, 5) || left(arg_iban, 4);
	iban_arr := string_to_array(arg_iban, null);
	for i in 1 .. array_length(iban_arr, 1) loop
		if  not iban_arr[i] between '0' and '9' then
			iban_arr[i] := (array_position(letters, iban_arr[i]) + 9)::text;
                  -- or iban_arr[i] := (select o + 9 from unnest(letters) with ordinality as u(l, o) where l = iban_arr[i])::text;
                  -- which is in fact an implementation of array_position
		end if;
	end loop;
	arg_iban := array_to_string(iban_arr, '');
	-- raise notice '%', arg_iban;
	return (arg_iban::numeric % 97) = 1;
end;
$$;

-- Клас В
create or replace function public.iban_valid(arg_iban text)
returns boolean language plpgsql immutable as 
$$
declare 
	letters text[] := '{A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z}';
	arr_iban text[];
	i integer;
	mod_result integer;
begin 
	arg_iban := upper(arg_iban);
	arg_iban := regexp_replace(arg_iban, '[^A-Z0-9]', '', 'g');
	if not exists (
	select 1 from iban_sizes where country_abbrev = substr(arg_iban, 1, 2)
	and length(arg_iban) = iban_size
	) then 
		return false;
	end if;
	arg_iban := substring(arg_iban from 5) || left(arg_iban, 4);
	arr_iban := string_to_array(arg_iban, null);
	for i in 1 .. array_length(arr_iban, 1) loop
		if arr_iban[i] between 'A' and 'Z' then
			arr_iban[i] := (array_position(letters, arr_iban[i]) + 9)::text;
		end if;
	end loop;
	arg_iban = array_to_string(arr_iban, '');
	mod_result := arg_iban :: numeric % 97;

	raise notice '%', arg_iban;
	return mod_result = 1;
end;
$$;

select public.iban_valid('GB82 WEST 1234 5698 7654 32');

-- Клас А
-- Coming soon
