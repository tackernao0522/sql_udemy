SHOW DATABASES;

USE day_10_14_db;

SELECT * FROM employees;

-- UPDATE 更新したいテーブル SET 更新したい列 = 更新する値
UPDATE employees SET age = age+1 WHERE id =1;

SELECT * FROM employees;

SELECT
	*
FROM
	employees AS emp
WHERE
emp.department_id = (SELECT id FROM departments WHERE name = "営業部");

-- 営業部の人の年齢を+2する
UPDATE
	employees AS emp
SET  emp.age = emp.age+2
WHERE
emp.department_id = (SELECT id FROM departments WHERE name = "営業部");

SELECT * FROM employees;

-- INNER JOIN
SELECT * FROM employees;

ALTER TABLE employees
ADD department_name VARCHAR(255);

-- LEFT JOIN
SELECT emp.*, COALESCE(dt.name, "不明") FROM
employees AS emp
LEFT JOIN departments AS dt
ON emp.department_id  = dt.id;

UPDATE
employees AS emp
LEFT JOIN departments AS dt
ON emp.department_id  = dt.id
SET emp.department_name = COALESCE(dt.name, "不明")
;

SELECT * FROM employees;