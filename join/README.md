## JOINS

> [!IMPORTANT]
> Probably the most important thing in the relational database domain  
> (i.e. cooking) :relaxed:
```
<table-expression> ::= <table-name> [[AS] <alias>]
<table-expression> ::= <table-expression>
[
 INNER |
 LEFT [OUTER] |
 RIGHT [OUTER] |
 FULL [OUTER] |
 CROSS
] JOIN [LATERAL]
<table-expression>
ON <join-condition>
```
SQLite JOIN syntax diagram at [SQL As Understood By SQLite](https://devdoc.net/database/sqlite-3.0.7.2/lang_select.html)  

![join-operator](https://github.com/user-attachments/assets/1d283a35-15bd-46e5-8c46-d7ca8e1c9204)
