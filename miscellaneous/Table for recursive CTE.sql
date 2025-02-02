create table org_chart
(
 id integer not null primary key,
 full_name text not null,
 manager_id integer references org_chart(id),
 other_details jsonb not null default '{}'
);

-- truncate table org_chart;

insert into org_chart (id, full_name, manager_id)
values 
(101, 'CEO CE001', null),	-- Chief executive officer
(201, 'CTO_CT201', 101),	-- Chief technical officer, reports to CEO
(202, 'CFO_CF202', 101),	-- Chief financial officer, reports to CEO
(203, 'COO_CO203', 101),	-- Chief operations officer, reports to CEO
(204, 'CMO_CF204', 101),	-- Chief marketing officer, reports to CEO
(205, 'CIO_CO205', 101),	-- Chief information officer, reports to CEO
(301, 'MTD01_MT301', 201),	-- Manager of technical department 01, reports to CTO
(302, 'MTD02_MT302', 201),	-- Manager of technical department 02, reports to CTO
(303, 'MTD03_MT303', 201),	-- Manager of technical department 03, reports to CTO
(311, 'MFD01_MF311', 202),	-- Manager of financial department 01, reports to CFO
(312, 'MFD02_MF312', 202),	-- Manager of financial department 02, reports to CFO
(321, 'MID01_MI321', 205),	-- Manager of IT department 01, reports to CIO
(322, 'MID02_MI322', 205),	-- Manager of IT department 02, reports to CIO
(323, 'MID03_MI323', 205),	-- Manager of IT department 03, reports to CIO
(331, 'MOD01_MO331', 203),	-- Manager of operations department 01, reports to COO
(332, 'MOD02_MO332', 203),	-- Manager of operations department 02, reports to COO
(333, 'MOD03_MO333', 203),	-- Manager of operations department 03, reports to COO
(341, 'MMD01_MM341', 204);	-- Manager of marketing department 01, reports to CMO

insert into org_chart(id, full_name, manager_id)
with t as
(
 select 
   ('{301,302,303,311,312,321,322,323,331,332,333,341}'::integer[])[(random()*97)::integer % 11 + 1] as v,
   rn
 from generate_series(1, 150) as t(rn)
)
select 1000 + rn, 'EMPLOYEE.'||(2000 + rn)::text, v from t;

-- select * from org_chart;
