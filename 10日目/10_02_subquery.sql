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

