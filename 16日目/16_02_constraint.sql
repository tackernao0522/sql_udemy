SHOW DATABASES;

USE day_15_18_db;

SHOW TABLES;

SELECT * FROM employees;

DESCRIBE employees;

-- ALTER TABLE employees ADD CONSTRAINT uniq_employees_name UNIQUE(name); -- 既に重複しているnameが入っているのでエラーになる Taroが2つ入っている

UPDATE employees SET name="Jiro" WHERE  employee_code="00000002";

-- uniqueの追加
ALTER TABLE employees ADD CONSTRAINT uniq_employees_name UNIQUE(name);

-- 制約一覧の確認
SELECT
*
FROM information_schema.key_column_usage
WHERE
	table_name="employees";

-- 制約の削除
ALTER TABLE employees DROP CONSTRAINT uniq_employees_name;

-- uniqueの追加
ALTER TABLE employees ADD CONSTRAINT uniq_employees_name_age UNIQUE(name, age);

SELECT * FROM employees;

-- INSERT INTO employees VALUES(2, "00000003", "Taro", 19); エラーになる

-- CREATE文を確認

-- DEFAULT追加
SELECT * FROM customers;

SHOW CREATE TABLE customers;

-- CHECK制約の削除
ALTER TABLE customers DROP CONSTRAINT customers_chk_1;

DESCRIBE customers;

ALTER TABLE customers
ALTER age SET DEFAULT 20;

INSERT INTO customers(id, name) VALUES(2, "Jiro");

SELECT * FROM customers;

-- NOT NULLの追加
ALTER TABLE customers MODIFY name VARCHAR(255) NOT NULL;

INSERT INTO customers(id, name) VALUES(3, NULL); -- エラーになる

-- CHECK制約の追加
ALTER TABLE customers ADD CONSTRAINT check_age CHECK(age > 20); -- 既に20以下のレコードが入っているのでエラーになる

ALTER TABLE customers ADD CONSTRAINT check_age CHECK(age >= 20); 

DESCRIBE customers;

-- 主キーの削除
ALTER TABLE customers DROP PRIMARY KEY;

-- 主キーの追加
ALTER TABLE customers
ADD CONSTRAINT pk_customers PRIMARY KEY(id);

-- 外部キー
DESCRIBE students;

SHOW CREATE TABLE students;

ALTER TABLE students DROP CONSTRAINT students_ibfk_1;

ALTER TABLE students
ADD CONSTRAINT fk_schools_students
FOREIGN KEY(school_id) REFERENCES schools(id);
