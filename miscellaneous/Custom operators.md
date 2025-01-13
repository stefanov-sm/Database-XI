## User defined [operators](https://www.postgresql.org/docs/current/sql-createoperator.html) in PostgreSQL
#### (Oracle is similar with a different [syntax](https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/CREATE-OPERATOR.html))  
.
> [!CAUTION]
> **Use custom operators with care. Compatibility & portability issues may arise**

.

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
### JSONB scalar to text unary prefix operator
> [!NOTE]
> **Unary suffix operators are not supported**
```sql
create or replace function jsonb_text(j jsonb)
returns text immutable strict language sql as
$$
  select j #>> '{}'
$$;

create operator >> (rightarg = jsonb, function = jsonb_text);

-- Cleanup

drop operator >> (none, jsonb); -- Note "none" as the type of the missing leftarg
drop function jsonb_text;
```
#### Demo
```sql
with t(j) as (
values ('{"tx":"A text", "nested":{"x":1, "y": "one \"way\""}}'::jsonb),
       ('{"tx":"B text", "nested":{"x":2, "y": "two \"times\""}}'::jsonb)
)
select
    j['tx'] as tx_as_json,
  >>j['tx'] as tx_as_text, 
    j['nested']['x'] as x_as_json,
    j['nested']['y'] as y_as_json,
  >>j['nested']['y'] as y_as_text
from t;
```
![image](https://github.com/user-attachments/assets/8b76c368-1c82-4abb-a932-9b5572c5e630)
