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