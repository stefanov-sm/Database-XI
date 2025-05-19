-- https://dbfiddle.uk/_9Xjjnxj

create or replace function in_range_list(vx number, range_list varchar2, range_delim varchar2 default '-') return varchar2 as
 retval varchar2(5);
 exclude integer;
 v_range_list varchar2(1024);

 RV_YES constant varchar2(5) := 'TRUE';
 RV_NO  constant varchar2(5) := 'FALSE';

begin
 if range_list is null then return RV_YES; end if;
 if vx is null then return RV_YES; end if;

 if regexp_like(range_list, '^(<>|><|!)') then
    exclude := 1;
    v_range_list := ltrim(range_list, '<>! ');
 else
    exclude := 0;
    v_range_list := range_list;
 end if;

 with t(rli) as
 (
   select regexp_substr(v_range_list, '[^,]+', 1, level) from dual
   connect by level <= length(v_range_list) - length(replace(v_range_list, ',')) + 1
 )
 select case when exists
 (
   select 1 from t
   where instr(rli, range_delim) = 0 and cast(rli as number) = vx -- scalar
   or vx between cast(substr(rli, 1, instr(rli,range_delim) - 1) as number) -- range
             and cast(substr(rli, instr(rli,range_delim) + length(range_delim)) as number)
 ) then RV_YES else RV_NO end
 into retval from dual;

 if exclude = 1 then 
   select decode(retval, RV_YES, RV_NO, RV_NO, RV_YES) into retval from dual;
 end if;
 return retval;
end;
/

create or replace function in_str_list(vs varchar2, str_list varchar2) return varchar2 as
 retval varchar2(5);
 exclude integer;
 v_str_list varchar2(1024);

 RV_YES constant varchar2(5) := 'TRUE';
 RV_NO  constant varchar2(5) := 'FALSE';

begin
 if str_list is null then return RV_YES; end if;
 if vs is null then return RV_NO; end if;

 if regexp_like(str_list, '^(<>|><|!)') then
    exclude := 1;
    v_str_list := ltrim(str_list, '<>! ');
 else
    exclude := 0;
    v_str_list := str_list;
 end if;

 with t(sli) as
 (
   select regexp_substr(v_str_list, '[^,]+', 1, level) from dual
   connect by level <= length(v_str_list) - length(replace(v_str_list, ',')) + 1
 )
 select case when exists (select 1 from t where vs = sli) then RV_YES else RV_NO end 
 into retval
 from dual;

 if exclude = 1 then 
   select decode(retval, RV_YES, RV_NO, RV_NO, RV_YES) into retval from dual;
 end if;
 return retval;
end;
/

select in_range_list(5, '1,2,3') a,
       in_range_list(20, '1, 2, 3, -8 .. 29,121', '..') b,
       in_range_list(99, null) c,
       in_range_list(9, '9') d,
       in_range_list(5, '!1,2,3') e,
       in_range_list(6, '<>1,2,3,5 - 15') f,
       in_range_list(null, '1,2,3,5 - 15') g,
       in_range_list(null, null) h,
       in_str_list('ALA', 'ALA,BALA') i,
       in_str_list('ALA', '<>ALAS,BALAS') j
from dual;