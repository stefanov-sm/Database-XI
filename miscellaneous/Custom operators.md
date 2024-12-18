> [!CAUTION]
> **Use custom operators with care. Compatibility & portability issues may arise**

![MSSQL](https://github.com/user-attachments/assets/20c7a903-ef31-4cf8-86da-ff696485f0dc)
### String concatenation MS-SQL Server style operator
```sql
create or replace function text_concat (a text, b text)
returns text language sql immutable strict parallel safe as
$$
  select a || b;
$$;

create operator + 
(
  leftarg = text, rightarg = text, function = text_concat
);

select 'Hello' + ' plus ' + 'operator' + '!';

-- Cleanup

drop operator + (text, text);
drop function text_concat;

```  
![resistors-in-parallel](https://github.com/user-attachments/assets/39d82858-de23-4bed-9253-8ba6bc95af96) ![capacitors](https://github.com/user-attachments/assets/c9af2b85-5e3b-4d3e-a3c8-47cb1d8724a5)
### Resistors in parallel, capacitors in series operator
```sql
create or replace function rpar(r1 numeric, r2 numeric)
returns numeric language sql immutable strict parallel safe as
$$
  select (r1 * r2)/(r1 + r2);
$$;

create operator || 
(
  leftarg = numeric, rightarg = numeric, function = rpar
);

select 12 || 10;

-- Cleanup

drop operator || (numeric, numeric);
drop function rpar;
```
