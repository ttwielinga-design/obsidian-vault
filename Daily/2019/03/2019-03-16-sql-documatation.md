---
title: "SQL documatation"
date: 2019-03-16
source_file: "PERSONAL\SCHOOL\Gregorius\Informatica\SQL documatation.docx"
source_type: docx
tags: [personal]
area: Areas
status: active
confidence: 0.8
imported: 2026-05-14
---

SQL development
If you're new to SQL, you can learn more from this course: SQL.
Creating tables
CREATE TABLE customers (id INTEGER PRIMARY KEY, name TEXT, age INTEGER, weight REAL);
Many data types
CREATE TABLE customers (id INTEGER PRIMARY KEY, age INTEGER);
Using primary keys
See also: specifying defaults, using foreign keys. For more details, see the following: SQLite reference for CREATE.
Inserting data
INSERT INTO customers VALUES (73, "Brian", 33);
Inserting data
INSERT INTO customers (name, age) VALUES ("Brian", 33);
Inserting data for named columns
See also: The SQLite reference for INSERT.
Querying data
SELECT * FROM customers;
Select everything
SELECT * FROM customers WHERE age > 21;
Filter with condition
SELECT * FROM customers WHERE age < 21 AND state = "NY";
Filter with multiple conditions
SELECT * FROM customers WHERE plan IN ("free", "basic");
Filter with IN
SELECT name, age FROM customers;
Select specific columns
SELECT * FROM customers WHERE age > 21 ORDER BY age DESC;
Order results
SELECT name, CASE WHEN age > 18 THEN "adult" ELSE "minor" END "type" FROM customers;
Transform with CASE
See also: filtering with LIKE, restricting with LIMIT, using ROUND and other core functions. For more details, see: the SQLite reference for SELECT.
Aggregating data
SELECT MAX(age) FROM customers;
Aggregate functions
SELECT gender, COUNT(*) FROM students GROUP BY gender;
Grouping data
See also: restricting results with HAVING.
Joining related tables
SELECT customers.name, orders.item FROM customers JOIN orders ON customers.id = orders.customer_id;
Inner join
SELECT customers.name, orders.item FROM customers LEFT OUTER JOIN orders ON customers.id = orders.customer_id;
Outer join
Updating and deleting data
UPDATE customers SET age = 33 WHERE id = 73;
Updating data
DELETE FROM customers WHERE id = 73;
Deleting data
Also see: ALTER TABLE.

