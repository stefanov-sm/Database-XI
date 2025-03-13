create table tests.notifier 
(
  id integer primary key generated always as identity,
  v integer
);

create or replace function tests.notifier_tf() returns trigger language plpgsql as
$$
begin
  if new.v > 1000 then
    perform pg_notify(coalesce(TG_ARGV[0], 'general'), to_json(new)::text);
  end if;
  return null;
end;
$$;

create trigger notifier_t after insert
on tests.notifier for each row
execute function tests.notifier_tf('rita');

-- Unit test
insert into tests.notifier (v)
values (10), (1001), (10001), (200000);
