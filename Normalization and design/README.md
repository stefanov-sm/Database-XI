## Database normalization
A very good [Wikipedia](https://en.wikipedia.org/wiki/Database_normalization) article
### Why bother? Database anomalies (by AI)
Database anomalies are inconsistencies or errors in a database that result from poor design, leading to problems during insertion, deletion, or update operations. The three main types are insertion anomalies, which prevent adding new data, deletion anomalies, which cause unintended data loss when a record is deleted, and update anomalies, which lead to inconsistencies when modifying data that is stored in multiple places. These issues are typically addressed by normalizing the database, a process that organizes tables to minimize redundancy and dependency.  

#### Types of database anomalies
-    Insertion anomaly: Occurs when you cannot add new data to a table because some required information is missing.
        Example: You cannot add a new customer's information until a sale has been made and recorded for them.
-    Deletion anomaly: Happens when deleting a record unintentionally erases other, unrelated data.
        Example: Deleting a customer from a table might also delete their purchase history if all the information is stored in the same table.
-    Update anomaly: Arises when updating a piece of data that is stored in multiple places, and the update is not applied to all instances.
        Example: If a customer's address is stored in multiple rows, changing it in one row but not the others creates an inconsistency. 

#### Causes of anomalies
-    Storing all data in a single, "flat" table rather than a normalized set of tables.
-    High levels of data redundancy, where the same information is repeated in multiple locations.
-    Poorly designed relationships between tables, such as a lack of proper primary and foreign keys.

### Database Normalization (by DigitalOcean)
#### [Introduction and misc](https://www.digitalocean.com/community/tutorials/database-normalization#introduction)
#### [First normal form (1NF)](https://www.digitalocean.com/community/tutorials/database-normalization#first-normal-form-1nf)
#### [Second normal form (2NF)](https://www.digitalocean.com/community/tutorials/database-normalization#second-normal-form-2nf)
#### [Third normal form (3NF)](https://www.digitalocean.com/community/tutorials/database-normalization#third-normal-form-3nf)
#### [Boyce-Codd normal form (BCNF)](https://www.digitalocean.com/community/tutorials/database-normalization#boyce-codd-normal-form-bcnf)
·  
### More Good stuff on database design and normalization.
Have a look at [Database Normalization – 1NF 2NF 3NF Table Examples](https://www.freecodecamp.org/news/database-normalization-1nf-2nf-3nf-table-examples/)  
or [Normalization in SQL: A Beginner’s Guide](https://www.datacamp.com/tutorial/normalization-in-sql)
