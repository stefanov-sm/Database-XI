create table tests.notifier 
(
  id integer primary key generated always as identity,
  v integer
);

create or replace function tests.notifier_tf() returns trigger language plpgsql as
$$
declare
  channel_name text;
  message_payload text;
begin
  if new.v > 1000 then
    CHANNEL_NAME := coalesce(TG_ARGV[0], 'general');
    message_payload := to_json(new);
    perform pg_notify(channel_name, message_payload);
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
