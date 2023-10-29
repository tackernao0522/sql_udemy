# 副問い合わせとは
/*
SELECT文をFROMの中やWHEREの中などに記述して、SELECTの結果を処理に用いるSQL文
メインのSELECT文以外のSELECTをサブクエリ(副問い合わせ)という。
メインのSELECT文をメインクエリ(主問い合わせ)という。
*/

SHOW TABLES;

SELECT * FROM employees;

-- 部署一覧
SELECT * FROM departments;

-- INで絞り込む
SELECT * FROM  employees
	WHERE department_id IN (1, 2);
	
-- 副問い合わせを使う
SELECT id FROM departments
	WHERE name IN ("経営企画部", "営業部");

SELECT * FROM employees 
	WHERE department_id 
		IN (SELECT id FROM departments WHERE name IN ("経営企画部", "営業部")
		);
	
SELECT * FROM employees 
	WHERE department_id 
		IN (SELECT id FROM departments WHERE name NOT IN ("経営企画部", "営業部")
		);
	
SELECT * FROM students;
SELECT * FROM users;

-- 複数カラムのIN(副問い合わせ)
SELECT * FROM students
	WHERE (first_name, last_name)  IN (
SELECT first_name, last_name FROM users
);

SELECT * FROM students
	WHERE (first_name, last_name) NOT IN (
SELECT first_name, last_name FROM users
);

-- 副問い合わせ(集計関数と使う)
SELECT MAX(age) FROM employees;

SELECT * FROM employees
	WHERE age = (SELECT MAX(age) FROM employees);

SELECT * FROM employees
	WHERE age < (SELECT MAX(age) FROM employees);

SELECT * FROM employees
	WHERE age < (SELECT AVG(age) FROM employees);

-- 副問い合わせ4: FROMで用いる
SELECT
	MAX(avg_age) AS "部署ごとの平均年齢の最大"
	FROM
	(SELECT department_id, AVG(age) AS avg_age FROM employees GROUP BY department_id) AS tmp_emp;
	
SELECT
	MAX(avg_age) AS "部署ごとの平均年齢の最大",
	MIN(avg_age) AS "部署ごとの平均年齢の最小"
	FROM
	(SELECT department_id, AVG(age) AS avg_age
		FROM employees GROUP BY department_id
		) 
			AS tmp_emp;

-- 年代の集計
SELECT *
	FROM employees
	GROUP BY id, FLOOR(age / 10);

SELECT FLOOR(age / 10) * 10, COUNT(*) AS age_count 
	FROM employees
	GROUP BY FLOOR(age / 10) * 10;

SELECT 
	MAX(age_count),
	MIN(age_count)
FROM
(SELECT FLOOR(age / 10) * 10, COUNT(*) AS age_count 
	FROM employees
	GROUP BY FLOOR(age / 10) * 10) AS age_summary;

-- 副問い合わせ5: SELECTの中に書く
SELECT * FROM customers;

SELECT * FROM orders;

SELECT
	cs.id,
	cs.first_name,
	cs.last_name,
	(
		SELECT MAX(order_date) FROM orders AS order_max 
		WHERE cs.id = order_max.customer_id
	) AS "最近の注文日"
	FROM customers AS cs
	WHERE 
		cs.id < 10;
	
SELECT
	cs.id,
	cs.first_name,
	cs.last_name,
	(
		SELECT MAX(order_date) FROM orders AS order_max 
		WHERE cs.id = order_max.customer_id
	) AS "最近の注文日",
	(
		SELECT MIN(order_date) FROM orders AS order_max 
		WHERE cs.id = order_max.customer_id
	) AS "古い注文日"
	FROM customers AS cs
	WHERE 
		cs.id < 10;
	
SELECT MAX(order_date) FROM orders AS order_max 
		WHERE 1 = order_max.customer_id;
	
SELECT * FROM orders;

SELECT order_amount * order_price FROM orders;

SELECT
	cs.id,
	cs.first_name,
	cs.last_name,
	(
		SELECT MAX(order_date) FROM orders AS order_max 
		WHERE cs.id = order_max.customer_id
	) AS "最近の注文日",
	(
		SELECT MIN(order_date) FROM orders AS order_max 
		WHERE cs.id = order_max.customer_id
	) AS "古い注文日",
	(
		SELECT SUM(order_amount * order_price) FROM orders AS tmp_order WHERE cs.id = tmp_order.customer_id
	) AS "全支払い金額"
	FROM customers AS cs
	WHERE 
		cs.id < 10;

-- 副問い合わせ6: CASEと使う
SELECT 
	emp.*,
	CASE
	WHEN emp.department_id = (SELECT id FROM departments WHERE name="経営企画部")
	THEN "経営層"
	ELSE "その他"
	END AS "役割"
FROM
	employees AS emp;

SELECT * FROM salaries WHERE payment > (SELECT AVG(payment)  FROM salaries);

SELECT
	emp.*,
	CASE
		WHEN emp.id IN (
		SELECT DISTINCT employee_id FROM salaries WHERE payment > (SELECT AVG(payment)  FROM salaries)
		) THEN "○"
		ELSE "x"
		END AS "給料が平均より高いか"
FROM
employees emp;
