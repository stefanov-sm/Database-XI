create table state (
	id serial primary key,
	state_name text not null,
	details jsonb not null default '{}'
);

drop table if exists state;

create table signal (
	id serial primary key,
	signal_name text not null,
	details jsonb not null default '{}'
);

drop table if exists signals;

create table transition (
	signal_id integer not null references signal(id),
	in_state_id integer not null references state(id),
	out_state_id integer not null references state(id),
	transition_handler text not null default '',
	details jsonb not null default '{}'
);

drop table if exists transitions;

create table sm_unit (
id serial primary key,
unit_name text not null,
unit_details jsonb not null default '{}'
);

insert into state (state_name) values ('registered'),('assigned'),('dispatched'),
('start of service'),('end of service'),('reported');

insert into signal(signal_name) values ('customer call'),('assign'),('dispatch'),
('arrive'),('parts missing'),('parts picked ok'),('parts picked failed'),
('finished work ok'),('finished work failed'),('customer notification');

insert into state (state_name)values ('neutral');
insert into state (state_name)values ('parts missing');
insert into signal (signal_name)values ('time interval');
select * from state;

insert into transition (signal_id,in_state_id,out_state_id) values 
(1,7,1), --customer call, neutral->registered
(2,1,2),--assign, registered->assign
(3,2,3),--dispatched, assign->dispatched
(4,3,4),--arrive, dispatched->start of service
(5,4,8),--parts missing, start of service->parts missing
(6,8,4),--parts picked ok, parts missing->start of service
(7,8,2) --parts picked failed, parts missing->assign

select s.signal_name,s2.state_name as in_state,s3.state_name as out_state
from transition t join signal s on s.id = signal_id 
join state s2 on s2.id = in_state_id 
join state s3 on s3.id=out_state_id 
