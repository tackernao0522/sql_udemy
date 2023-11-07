SHOW DATABASES;

USE day_10_14_db;

SHOW TABLES;

SELECT * FROM employees; # department_idを持っている

SELECT * FROM departments;

-- INNER JOINは下記の例で言うとdepartment_idが存在しないものは表示されない(紐付けできない部分は表示されない)

-- 通常のJOIN
SELECT * FROM employees AS emp
	INNER JOIN departments AS dt
	ON emp.department_id = dt.id;

-- 特定のカラムを取り出す
SELECT emp.id, emp.first_name, emp.last_name, dt.id AS department_id, dt.name AS department_name 
	FROM employees AS emp
		INNER JOIN departments AS dt
			ON emp.department_id = dt.id;
		
-- 複数のレコードを紐付ける
SELECT * FROM students AS std
	INNER JOIN users AS usr
		ON std.first_name = usr.first_name
			AND std.last_name = usr.last_name;
		
-- =以外で紐付ける
SELECT * FROM employees AS emp
	INNER JOIN students AS std
		ON emp.id < std.id;

/*
LEFT (OUTER) JOIN
複数のテーブルを結合して、左のテーブルは全てのレコードを取得して、
右のテーブルからは紐付けのできたレコードのみを取り出し、それ以外はNULLとして表示される
*/
SELECT emp.id, emp.first_name, emp.last_name, dt.id AS department_id, dt.name AS department_name 
	FROM employees AS emp
		LEFT JOIN departments AS dt
			ON emp.department_id = dt.id;
		
SELECT emp.id, emp.first_name, emp.last_name, COALESCE(dt.id, "該当なし") AS department_id, dt.name AS department_name 
	FROM employees AS emp
		LEFT JOIN departments AS dt
			ON emp.department_id = dt.id;

# 多対多の紐付け  enrollmentsテーブルは中間テーブル
SELECT * FROM students AS std
	LEFT JOIN enrollments AS enr -- class_idがある
		ON std.id = enr.student_id
			LEFT JOIN classes AS cs
				ON enr.class_id  = cs.id;

/*
RIGHT (OUTER) JOIN
複数のテーブルを結合して、右のテーブルは全てのレコードを取得して、左のテーブルからは
紐付けのできたレコードのみを取り出し、それ以外はNULLとして表示される
*/
SELECT * FROM students AS std
	RIGHT JOIN enrollments AS enr -- class_idがある
		ON std.id = enr.student_id
			RIGHT JOIN classes AS cs
				ON enr.class_id  = cs.id;

/*
FULL OUTER JOIN (LEFT JOINとRIGHT JOINが合わさったようなもの)
複数のテーブルを結合して、結合できなかった行はNULLと表示する結合方法
MySQL(ver.8.028 の時点)では、FURLL OUTER JOINを利用できないのでUNIONを利用する。ただ処理時間はかかる
*/
SELECT * FROM students AS std
	LEFT JOIN enrollments AS enr -- class_idがある
		ON std.id = enr.student_id
			LEFT JOIN classes AS cs
				ON enr.class_id  = cs.id
UNION
SELECT * FROM students AS std
	RIGHT JOIN enrollments AS enr -- class_idがある
		ON std.id = enr.student_id
			RIGHT JOIN classes AS cs
				ON enr.class_id  = cs.id;
			
/*
customers, orders, items, stores を紐付ける(INNER JOIN)
customers.idで並び替える(ORDER BY)
*/
SELECT
	ct.id, ct.last_name, od.item_id, od.order_amount, od.order_price, od.order_date, it.name, st.name
	FROM customers AS ct
		INNER JOIN orders AS od
			ON od.customer_id = ct.id
				INNER JOIN items AS it
					ON od.item_id = it.id
						INNER JOIN stores AS st
							ON it.store_id = st.id
								ORDER BY ct.id;
				
/*
customers, orders, items, stores を紐付ける(INNER JOIN)
customers.idで並び替える(ORDER BY)
customers.idが10で、orders.order_dateが 2020-08-01より後に絞り込む(WHERE)
*/
SELECT
	ct.id, ct.last_name, od.item_id, od.order_amount, od.order_price, od.order_date, it.name, st.name
	FROM customers AS ct
		INNER JOIN orders AS od
			ON od.customer_id = ct.id
				INNER JOIN items AS it
					ON od.item_id = it.id
						INNER JOIN stores AS st
							ON it.store_id = st.id
								WHERE ct.id = 10 AND od.order_date > "2020-08-01"
									ORDER BY ct.id;

-- サブクエリ 上記を同じ結果になる
SELECT
	ct.id, ct.last_name, od.item_id, od.order_amount, od.order_price, od.order_date, it.name, st.name
	FROM (SELECT * FROM customers WHERE id=10) AS ct
		INNER JOIN (SELECT * FROM orders WHERE order_date > "2020-08-01") AS od
			ON od.customer_id = ct.id
				INNER JOIN items AS it
					ON od.item_id = it.id
						INNER JOIN stores AS st
							ON it.store_id = st.id
								ORDER BY ct.id;

-- GROUP BY の紐付け
SELECT * FROM customers AS ct
	INNER JOIN
		(SELECT customer_id, SUM(order_amount * order_price) AS summary_price
			FROM orders
				GROUP BY customer_id) AS order_summary
					ON ct.id = order_summary.customer_id
						ORDER BY ct.age
							LIMIT 5;
