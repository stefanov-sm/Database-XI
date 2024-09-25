### VERY BASIC SQL SYNTAX
```SQL
<operator> ::= +|-|*|/|=|<>|>|>=|<|<=|AND|OR|NOT|IS [NOT] NULL|IS [NOT] DISTINCT FROM|IN|BETWEEN|CASE ;Among others

<SELECT-STATEMENT> ::=
  SELECT <expression> [[AS] <alias>] [, <expression> [[AS] <alias>]]*
  [FROM <table-expression> [[AS] <alias>]]
  [WHERE <expression>]
  [GROUP BY <expression>[, <expression>]* [HAVING <expression>]]
  [ORDER BY <gb-expression>[, <gb-expression>]*]

<table-expression> ::= <table-name> ;At least for now
<gb-expression> ::= <expression> [ASC|DESC] [NULLS FIRST|NULLS LAST]

<INSERT-STATEMENT> ::=
  INSERT INTO <table-name> [(<list-of-fields>)] 
  VALUES (<list-of-values>) [, (<list-of-values>)]*

<DELETE-STATEMENT> ::=
  DELETE FROM <table-name> [WHERE <expression>]

<UPDATE-STATEMENT> ::=
  UPDATE <table-name> SET <field-name> = <expression> [, <field-name> = <expression>]*
  [WHERE <expression>]

<TRUNCATE-STATEMENT> ::=
  TRUNCATE TABLE <table-name>

<table-expression> ::= <table-name>|<subquery-with-alis>[<join_condition> <table-expression>]*
