drop table if exists dropme;
create table dropme (num1 numeric, num2 numeric, t1 text);
insert into dropme values(10, 20, 'dog'), (15, 25, 'cat'), (19, 21, 'rabbit');
select * from dropme;

------------------------------------
-- A trigger to skip trivial updates

create or replace function no_trivial_update()
returns trigger language plpgsql as 
$$
begin 
  raise notice 'Trigger fired';
  if to_jsonb(new) = to_jsonb(old) then
    raise notice 'NULL returned';
    return null;
  else
    raise notice 'NEW returned';
    return new;
  end if;
end;
$$;

create or replace trigger bt_u
before update on dropme for each row
execute function no_trivial_update();

update dropme set t1 = 'dog' where num1 = 10;
update dropme set t1 = 'Dog' where num1 = 10;
drop trigger bt_u on dropme;

------------------------------
-- A trigger to disable DELETE

create or replace function no_delete()
returns trigger language plpgsql as
$$
begin
  return null;
end;
$$;

create or replace trigger bt_d
before delete on dropme for each row
execute function no_delete();

delete from dropme where num1 = 10;
drop trigger bt_d on dropme;
drop table if exists dropme;
