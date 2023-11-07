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
