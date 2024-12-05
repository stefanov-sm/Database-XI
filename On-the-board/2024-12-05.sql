-- drop table if exists public.iban_sizes;
create table public.iban_sizes (
 country_abbrev text primary key,
 iban_size integer check (iban_size between 10 and 50),
 notes text 
 );
insert into public.iban_sizes (notes, country_abbrev, iban_size) values
('Албания','AL','28'),('Андора','AD','24'),('Австрия','AT','20'),('Азербайджан','AZ','28'),
('Бахрейн','BH','22'),('Белгия','BE','16'),('Босна и Херцеговина','BA','20'),('България','BG','22'),
('Хърватия','HR','21'),('Кипър','CY','28'),('Чехия','CZ','24'),('Дания','DK','18'),
('Естония','EE','20'),('Финландия','FI','18'),('Франция','FR','27'),('Грузия','GE','22'),
('Германия','DE','22'),('Гърция','GR','27'),('Унгария','HU','28'),('Исландия','IS','26'),
('Ирландия','IE','22'),('Италия','IT','27'),('Казахстан','KZ','20'),('Косово','XK','20'),
('Латвия','LV','21'),('Ливан','LB','28'),('Лихтенщайн','LI','21'),('Литва','LT','20'),
('Люксембург','LU','20'),('Малта','MT','31'),('Монако','MC','27'),('Черна Гора','ME','22'),
('Нидерландия','NL','18'),('Македония','MK','19'),('Норвегия','NO','15'),('Полша','PL','28'),
('Португалия','PT','25'),('Румъния','RO','24'),('Сан Марино','SM','27'),('Сърбия','RS','22'),
('Словакия','SK','24'),('Словения','SI','19'),('Испания','ES','24'),('Швеция','SE','24'),
('Швейцария','CH','21'),('Турция','TR','26'),('Великобритания','GB','22');

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
