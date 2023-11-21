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
SHOW CREATE TABLE employees;
