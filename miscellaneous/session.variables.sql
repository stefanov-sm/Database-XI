-- Session variables' wrappers
-- S. Stefanov, June-2025

create or replace function getv(varname text)
returns text language plpgsql as $$
begin
	return current_setting('user_session_var__.'||varname);
exception when others then
	return null;
end;
$$;

create or replace function setv(varname text, val text)
returns text language sql as $$
	select set_config('user_session_var__.'||varname, val, false);
$$;
