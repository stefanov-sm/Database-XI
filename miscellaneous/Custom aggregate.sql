create type rms_state_t as (cnt integer, accumulator numeric);

create or replace function rms_state_f(rms_state rms_state_t, rv numeric)
returns rms_state_t language sql as
$$
  select case
   when rv is null then rms_state
   when rms_state is null then (1, rv * rv)::rms_state_t
   else (rms_state.cnt + 1, rms_state.accumulator + rv * rv)::rms_state_t
  end;
$$;

create or replace function rms_final_f(final_state rms_state_t)
returns numeric language sql as
$$
  select sqrt(final_state.accumulator / final_state.cnt);
$$;

create or replace aggregate rms(numeric)
(
 STYPE = rms_state_t,
 SFUNC = rms_state_f,
 FINALFUNC = rms_final_f
);

with t(v) as (
 values (10),(2),(3),(44),(5)
)
select rms(v) from t
-- where v > 100;
