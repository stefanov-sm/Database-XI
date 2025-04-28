create or replace function sm.new_sm_unit (details jsonb, arg_unit_name text) returns integer
language sql
as
$$
	insert into sm.sm_unit(unit_name, unit_details)
	values(
	arg_unit_name, details
	)
	returning id;
$$;

select sm.new_sm_unit('{"MIF": "AEG washing machine", "SN": "12345", "Customer": "Gergana"}', 'Service call Gergana');
select sm.new_sm_unit('{"MIF": "Philips Hair dryer", "SN": "54321", "Customer": "Boryana"}', 'Service call Boryana');
select sm.new_sm_unit('{"MIF": "Plumbing", "Symptom": "leak", "SN": null, "Customer": "Stefan"}', 'Service call Stefan');

create or replace function handle_signal(unit_id integer, signal_id integer, details jsonb) returns integer
language plpgsql
as
$$
begin
	-- Implementation here
end;
$$;

create or replace function unit_status(arg_unit_id integer) returns table (status_id integer, status_name text, details jsonb)
language plpgsql
as
$$
	declare
		var_state integer;
		var_payload jsonb;
		INITIAL_STATE constant integer default 0;
	begin
		select final_state_id, payload into var_state, var_payload from sm.sm_log
		where arg_unit_id=unit_id order by ts desc limit 1;
		status_id := COALESCE(var_state, INITIAL_STATE);
		status_name := (select state_name from sm.state where id=status_id);
		details := COALESCE(var_payload,
			(
			select unit_details from sm.sm_unit where id=unit_id
			)
		);
		return next;
	end;
$$

	
	
	
	

create table if not exists sm_log(
unit_id integer, initial_state_id integer, 
final_state_id integer, payload jsonb,
ts timestamptz not null default current_timestamp
);


alter table sm_log set schema sm;

-- Something critically important is missing, right?