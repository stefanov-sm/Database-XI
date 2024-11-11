# PostgreSQL [psycopg](https://www.psycopg.org/psycopg3/docs/basic/index.html) and Python [DB-API 2.0](https://peps.python.org/pep-0249/)
> [!TIP]
> If not already there:
> 
> [Download](https://www.python.org/downloads/) and run **Python 3** installer  
> Install **psycopg**. Run `path-to\pip install psycopg`
> 
> (usually `C:\Users\<user>\AppData\Local\Programs\Python\Python313\Scripts\pip`)
## I. Connection
### psycopg connection using a connection string  

```Python
import psycopg as pg

# Literal connection string
connectionstring = "host='localhost' dbname='my_database' user='postgres' password='secret'"

# Interpolated connection string
conn_paramaters = ('the_database', 'the_user', 'secret', 'the_host', 5432) # these may come from somewhere else
connectionstring = "dbname='%s' user='%s' password='%s' host='%s' port=%s" % conn_paramaters

conn = pg.connect(connectionstring)
```
### psycopg connection using separate arguments

```Python
conn = pg.connect(dbname='the_database', user='the_user', password='secret', host='the_host', port=5432)
```

### psycopg connection using environment variables
```Python
conn = pg.connect('')
```
**Variables:**  
- PGHOST
- PGPORT
- PGHOSTADDR
- PGDATABASE
- PGUSER
- PGPASSWORD
  
More in the [documentation](https://www.postgresql.org/docs/current/libpq-envars.html)

## II. Statement, weirdly called [cursor](https://www.psycopg.org/psycopg3/docs/api/cursors.html#the-cursor-class) in Python

```python
stmt = conn.cursor()
```
#### a good structure example
```Python
with pg.connect(connectionstring) as conn:
  with conn.cursor() as stmt:
    # stmt.execute and stmt.fetch* statements
    conn.commit()
```
#### step by step
```Python
import psycopg as pg

# these shall come from a safe place
conn_paramaters = ('practice', 'postgres', 'TheLongPassword', 'localhost', 5432)

connectionstring = "dbname='%s' user='%s' password='%s' host='%s' port=%s" % conn_paramaters

# this may come from a SQL module
sql = 'select * from class_a.unit'

conn = pg.connect(connectionstring)
stmt = conn.cursor()
stmt.execute(sql)

res = stmt.fetchall()
print (res)

conn.commit()
stmt.close()
conn.close()
```
> [!NOTE]  
> You may have a look at [this](https://github.com/stefanov-sm/sql-methods-in-python) example

## III. *Must read*  

> [!IMPORTANT]
> [Passing parameters](https://www.psycopg.org/psycopg3/docs/basic/params.html) to SQL queries  
> Statement result format by [Row factories](https://www.psycopg.org/psycopg3/docs/advanced/rows.html)  
> [Transaction management](https://www.psycopg.org/psycopg3/docs/basic/transactions.html)
