USE day_10_14_db;

SHOW TABLES;

SELECT * FROM employees;

-- WINDOW関数
SELECT *,AVG(age) OVER()
FROM employees;

SELECT *,AVG(age) OVER(), COUNT(*) OVER()
FROM employees;

-- PARTITION BY: 分割してその中で集計する
SELECT *,AVG(age) OVER(PARTITION BY department_id) AS agv_age,
COUNT(*) OVER(PARTITION BY department_id) AS count_department
FROM employees;


SELECT *, COUNT(*) OVER(PARTITION BY FLOOR(age/10)) AS age_count, FLOOR(age/10)
FROM employees;

SELECT DISTINCT COUNT(*) OVER(PARTITION BY FLOOR(age/10)) AS age_count, FLOOR(age/10) * 10
FROM employees;

SELECT DISTINCT CONCAT(COUNT(*) OVER(PARTITION BY FLOOR(age/10)),"人") AS age_count, FLOOR(age/10) * 10
FROM employees;

SELECT *,SUM(order_amount*order_price) OVER(PARTITION BY order_date)
FROM orders;

SELECT *,DATE_FORMAT(order_date, '%Y/%m'),
SUM(order_amount*order_price) OVER(PARTITION BY DATE_FORMAT(order_date, '%Y/%m'))
FROM orders;

-- ORDER BY
SELECT 
*,
COUNT(*) OVER() AS tmp_count
FROM
employees;

SELECT 
*,
COUNT(*) OVER(ORDER BY age) AS tmp_count
FROM
employees;

SELECT *, SUM(order_price) OVER(ORDER BY order_date) FROM orders;

SELECT *, SUM(order_price) OVER(ORDER BY order_date DESC) FROM orders;

SELECT *, SUM(order_price) OVER(ORDER BY order_date, customer_id) FROM orders;

SELECT
FLOOR(age/10),
COUNT(*) OVER(ORDER BY FLOOR(age/10))
FROM employees;

-- PARTITION + ORDER BY
SELECT *,
COUNT(*) OVER(PARTITION BY department_id)
FROM employees;

SELECT *,
COUNT(*) OVER(PARTITION BY department_id ORDER BY age) AS count_value
FROM employees;

SELECT *,
COUNT(age) OVER(PARTITION BY department_id ORDER BY age) AS count_value
FROM employees;

SELECT *,
MAX(age) OVER(PARTITION BY department_id ORDER BY age) AS count_value
FROM employees;

SELECT *,
MIN(age) OVER(PARTITION BY department_id ORDER BY age) AS count_value
FROM employees;

-- 人ごとの、最大の収入
SELECT
*
FROM employees AS emp
INNER JOIN salaries AS sa
ON emp.id = sa.employee_id;

SELECT
*,
MAX(payment) OVER(PARTITION BY emp.id)
FROM employees AS emp
INNER JOIN salaries AS sa
ON emp.id = sa.employee_id;

-- 月ごとの、合計をemployeesのIDで昇順に並び替えて出す
SELECT
*,
MAX(sa.payment) OVER(PARTITION BY sa.paid_date ORDER BY emp.id)
FROM employees AS emp
INNER JOIN salaries AS sa
ON emp.id = sa.employee_id;

-- salesテーブルのorder_price * order_amountのの合計値の7日間の平均を求める
-- まずは、日付ごとの合計値を求める
-- 7日平均を求める
SELECT * FROM orders ORDER BY order_date;

SELECT *, SUM(order_price * order_amount) OVER(ORDER BY order_date) FROM orders;

-- これだとうまくいかない
SELECT *,
SUM(order_price * order_amount) 
OVER(ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
FROM orders;

-- これで想定通りになる
WITH daily_summary AS(
SELECT 
	order_date, SUM(order_price * order_amount) AS sale
	FROM
		orders
	GROUP BY order_date
)
SELECT
	*,
	AVG(sale) OVER(ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) -- 6行前から現在の行まで
FROM
	daily_summary;

-- 集計結果とemployeesテーブルを紐付けてその人ごとに給料の合計値を出す
SELECT
*
FROM employees AS emp
INNER JOIN
(SELECT 
	employee_id,
	SUM(payment) AS payment
FROM salaries
	GROUP BY employee_id) AS summary_salary
		ON emp.id = summary_salary.employee_id;

-- 年齢ごとに並び替えて全員の給料の合計値を出す。
SELECT
*,
SUM(summary_salary.payment)
OVER(ORDER BY age) AS p_summary
FROM employees AS emp
INNER JOIN
(SELECT 
	employee_id,
	SUM(payment) AS payment
FROM salaries
	GROUP BY employee_id) AS summary_salary
		ON emp.id = summary_salary.employee_id;

-- 一番最初の値から一番大きな値まで全部足している(全部同じ値になる)
SELECT
*,
SUM(summary_salary.payment)
OVER(ORDER BY age RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS p_summary
FROM employees AS emp
INNER JOIN
(SELECT 
	employee_id,
	SUM(payment) AS payment
FROM salaries
	GROUP BY employee_id) AS summary_salary
		ON emp.id = summary_salary.employee_id;

SELECT
*,
SUM(summary_salary.payment)
OVER(ORDER BY age RANGE BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) AS p_summary
FROM employees AS emp
INNER JOIN
(SELECT 
	employee_id,
	SUM(payment) AS payment
FROM salaries
	GROUP BY employee_id) AS summary_salary
		ON emp.id = summary_salary.employee_id;

SELECT
*,
SUM(summary_salary.payment)
OVER(ORDER BY age RANGE BETWEEN 3 PRECEDING AND CURRENT ROW) AS p_summary
FROM employees AS emp
INNER JOIN
(SELECT 
	employee_id,
	SUM(payment) AS payment
FROM salaries
	GROUP BY employee_id) AS summary_salary
		ON emp.id = summary_salary.employee_id;
