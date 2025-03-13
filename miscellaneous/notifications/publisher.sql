create table dropme.notifier 
(
  id integer primary key generated always as identity,
  v integer
);

create or replace function dropme.notifier_tf() returns trigger language plpgsql as
$$
declare
  msg_template text := null;
begin
  msg_template := case
    when new.v > 100000 then 'Huge one. ID is %s, V is %s'
    when new.v > 10000  then 'A large one. ID is %s, V is %s'
    when new.v > 1000   then 'Big fish. ID is %s, V is %s'
  end;
  if msg_template is not null then
    perform pg_notify(TG_ARGV[0], format(msg_template, new.id, new.v));
  end if;
  return null;
end;
$$;

create trigger notifier_t after insert
on dropme.notifier for each row
execute function dropme.notifier_tf('rita');

-- Unit test
insert into dropme.notifier (v) 
values (10), (1001), (10001), (200000);
