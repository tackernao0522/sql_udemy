USE day_10_14_db;

SELECT * FROM departments;

SELECT * FROM employees;

-- EXISTS

SELECT * FROM employees AS em
	WHERE EXISTS (
		SELECT * FROM departments AS dt WHERE em.department_id = dt.id # (SELECT は 1 でも idでも何でも良いので書くようにする)
	);

-- IN (上記の結果と同じになる EXiSTSの方がパフォーマンスが良い)

SELECT * FROM employees AS em
	WHERE em.department_id IN (SELECT id FROM departments);

SELECT * FROM employees AS em
	WHERE EXISTS (
		SELECT * FROM departments AS dt WHERE dt.name IN ("営業部", "開発部") AND em.department_id = dt.id
	);

SELECT * FROM customers AS ct
	WHERE EXISTS (SELECT * FROM orders AS od WHERE ct.id = od.customer_id AND od.order_date = "2020-12-31");

SELECT * FROM customers AS ct
	WHERE NOT EXISTS (SELECT * FROM orders AS od WHERE ct.id = od.customer_id AND od.order_date = "2020-12-31");

SELECT * FROM employees AS em1
	WHERE EXISTS (SELECT 1 FROM employees em2 WHERE em1.manager_id = em2.id);

SELECT * FROM employees AS em1
	WHERE EXISTS (SELECT 1 FROM employees em2 WHERE em2.manager_id = em1.id);

SELECT * FROM employees AS em1
	WHERE NOT EXISTS (SELECT 1 FROM employees em2 WHERE em2.manager_id = em1.id);
