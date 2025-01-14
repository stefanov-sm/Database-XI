-- MySQL group_concat aggregate implementation in PostgreSQL
-- for compatibility purposes

create or replace function concatf(container text[], runningValue text)
returns text[] language sql as
$$
 select case 
	when runningValue is null then container
	when container is null then array[runningValue]
	else container || runningValue -- equiv. to array_append(container, runningValue) 
 end;
$$;

create or replace function concatr(container text[])
returns text language sql as
$$
	select array_to_string(container, ',')
$$;

create or replace aggregate group_concat(text)
(
 STYPE = text[],
 SFUNC = concatf,
 FINALFUNC = concatr
);

-- Demo

create temporary table Tempp (
  s text
);
insert into Tempp values ('sharo'), ('drugo kuche'), ('magu');
select group_concat(s) from Tempp;


-- or a bit more more generic, note the anyelement pseudotype

create or replace function group_concat_f(container text[], runningValue anyelement)
returns text[] language sql as
$$
 select case 
   when runningValue is null then container
   when container is null then array[runningValue::text]
   else container || runningValue::text
 end;
$$;

create or replace aggregate group_concat(anyelement)
(
 STYPE = text[],
 SFUNC = group_concat_f,
 FINALFUNC = concatr
);
