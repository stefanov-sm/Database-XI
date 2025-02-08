# ----------------------------------------------------------
# Resolve SQL query return type for type-safety use
# PostgreSQL flavour. May differ a bit for other RDBMS
# S.Stefanov, Nov 2024
# ----------------------------------------------------------
import json
import psycopg
# ----------------------------------------------------------
def query_rettype(connectionstring, query):
  retval = {}
  try:
    with psycopg.connect(connectionstring) as conn:
      with conn.cursor() as stmt:
        stmt.execute(f'SELECT * from ({query}) as t limit 0')
        retval = {
          'status': True,
          'value': [{'name':x.name, 'type_code':x.type_code, 'type':x._type_display()} for x in stmt.description]
         }
  except Exception as err:
    retval = {'status': False, 'value': str(err)}
  return json.dumps(retval, indent = 2)

# ----------------------------------------------------------
# Unit test
# ----------------------------------------------------------
# CONNECTIONSTRING = 'host=localhost port=5432 dbname=postgres user=phpUser password=Baba123Meca'
# sql = 'select * from tests.the_table'
# print (query_rettype(CONNECTIONSTRING, sql))
# sql = 'select * Тук гръмни from tests.the_table'
# print (query_rettype(CONNECTIONSTRING, sql))
