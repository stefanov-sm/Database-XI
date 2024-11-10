## I. Connection
### psycopg connection using a connection string  

```python
import psycopg as pg

# Literal connection string
connectionstring = "host='localhost' dbname='my_database' user='postgres' password='secret'"

# Interpolated connection string
conn_paramaters = ('the_database', 'the_user', 'secret', 'the_host', 5432) # these may come from somewhere else
connectionstring = "dbname='%s' user='%s' password='%s' host='%s' port=%s" % conn_paramaters

conn = pg.connect(connectionstring)
```
### psycopg connection using separate arguments

```python
conn = pg.connect(dbname='the_database', user='the_user', password='secret', host='the_host', port=5432)
```

### psycopg connection using environment variables
```python
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

## II. Statement, weirdly called *cursor* in Python

```python
stmt = conn.cursor()
```
### an example
```python
with pg.connect(connectionstring) as conn:
  with conn.cursor() as stmt:
    # stmt.execute and stmt.fetch* statements
    stmt.commit()
```

## III. Items of special attention
- statement result format by [Row factories](https://www.psycopg.org/psycopg3/docs/advanced/rows.html)
- [transaction management](https://www.psycopg.org/psycopg3/docs/basic/transactions.html)
