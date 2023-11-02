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

	