### PostgreSQL [alter table](https://www.postgresql.org/docs/current/sql-altertable.html) statements
```sql
alter table orders
  add constraint orders_customer_fk foreign key (customer_id) references customers(customer_id);

alter table order_details
  add constraint order_details_orders_fk foreign key (order_id) references orders(order_id);

alter table order_details
  add constraint order_details_products_fk foreign key (product_id) references products(product_id);

alter table products
  add constraint products_category_fk foreign key (category_id) references categories(category_id);
```
### and the resulting [crow's foot entity-relationship diagram](https://vertabelo.com/blog/crow-s-foot-notation/) (ERD)
<img width="555" height="363" alt="image" src="https://github.com/user-attachments/assets/5c37f6ae-c279-4961-a027-efa1c107f204" />
