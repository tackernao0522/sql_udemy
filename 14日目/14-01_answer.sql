USE day_10_14_db;

SHOW TABLES;

/*
1. employeesテーブルとcustomersテーブルの両方から、それぞれidが10より小さいレコードを取り出します。

両テーブルのfirst_name, last_name, ageカラムを取り出し、行方向に連結します。

連結の際は、重複を削除するようにしてください。
*/

# my answer (answerと同じ結果になった)
SELECT DISTINCT e.first_name, e.last_name, e.age
FROM employees e
WHERE e.id < 10
UNION
SELECT DISTINCT c.first_name, c.last_name, c.age
FROM customers c
WHERE  c.id < 10;

# answer
SELECT first_name, last_name, age FROM employees WHERE id < 10
UNION
SELECT first_name, last_name, age FROM customers WHERE id < 10;

/*
2. departmentsテーブルのnameカラムが営業部の人の、月収の最大値、最小値、平均値、合計値を計算してください。

employeesテーブルのdepartment_idとdepartmentsテーブルのidが紐づけられ

salariesテーブルのemployee_idとemployeesテーブルのidが紐づけられます。

月収はsalariesテーブルのpaymentカラムに格納されています。
*/

# my answer (answerと同じ結果になった)
SELECT
	MAX(s.payment) AS max_salary,
	MIN(s.payment) AS min_salary,
	AVG(s.payment) AS avg_salary,
	SUM(s.payment) AS total_salary
FROM
	employees e
	JOIN departments d ON e.department_id = d.id
	JOIN salaries s ON e.id = s.employee_id
WHERE
	d.name = '営業部';

# answer
SELECT MAX(payment), MIN(payment), AVG(payment), SUM(payment)
FROM salaries AS sa
INNER JOIN employees AS emp
ON sa.employee_id  = emp.id
INNER JOIN departments AS dt
ON emp.department_id = dt.id
WHERE  dt.name = "営業部";

/*
3. classesテーブルのidが、5よりも小さいレコードとそれ以外のレコードを履修している生徒の数を計算してください。

classesテーブルのidとenrollmentsテーブルのclass_id、enrollmentsテーブルのstudent_idとstudents.idが紐づく

classesにはクラス名が格納されていて、studentsと多対多で結合される。
*/

# my ansewer (ansewerが正解)
SELECT
	c.id,
	COUNT(DISTINCT e.student_id) AS enrolled_students_count
FROM
	classes c
	JOIN enrollments e on e.id = e.class_id
WHERE
	c.id < 5
GROUP BY
	c.id
UNION
SELECT
	c.id,
	COUNT(DISTINCT e.student_id) AS enrolled_students_count
FROM
	classes c
	JOIN enrollments e ON c.id = e.class_id
WHERE
	c.id >= 5
GROUP BY
	c.id;

# answer
SELECT
CASE
	WHEN cls.id < 5 THEN "クラス1"
	ELSE "クラス2"
END	AS "クラス分類",
COUNT(std.id)
FROM classes AS cls
INNER JOIN enrollments AS enr
ON cls.id = enr.class_id
INNER JOIN students AS std
ON enr.student_id = std.id
GROUP BY
CASE
	WHEN cls.id < 5 THEN "クラス1"
	ELSE "クラス2"
END;

/*
4. ageが40より小さい全従業員で月収の平均値が7,000,000よりも大きい人の、月収の合計値と平均値を計算してください。

employeesテーブルのidとsalariesテーブルのemployee_idが紐づけでき、salariesテーブルのpaymentに月収が格納されています。
*/

# my answer (answerと同じ結果になった)
SELECT
	SUM(s.payment) AS total_salary,
	AVG(s.payment) AS average_salary
FROM
	employees e
	JOIN salaries s  ON e.id = s.employee_id
WHERE
	e.age < 40
GROUP BY
	e.id
HAVING
	AVG(s.payment) > 7000000;

# answer
SELECT emp.id, SUM(sa.payment), AVG(sa.payment)
FROM employees AS emp
	INNER JOIN salaries AS sa
	ON emp.id = sa.employee_id
WHERE emp.age < 40
GROUP BY emp.id
HAVING AVG(sa.payment) > 7000000;

/*
5. customer毎に、order_amountの合計値を計算してください。

customersテーブルとordersテーブルは、idカラムとcustomer_idカラムで紐づけができます

ordersテーブルのorder_amountの合計値を取得します。

SELECTの対象カラムに副問い合わせを用いて値を取得してください。
*/

# my answer (answerと同じ結果になった)
SELECT
    c.*,
    SUM(o.order_amount) AS sum_order_amount
FROM
    customers c
    LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY
    c.id, c.first_name, c.last_name, c.phone_number, c.age;

# answer
SELECT
*,
(SELECT SUM(order_amount) FROM orders AS od
	WHERE od.customer_id = cst.id
) AS sum_order_amount
FROM customers AS cst;

/*
6. customersテーブルからlast_nameに田がつくレコード、

ordersテーブルからorder_dateが2020-12-01以上のレコード、

storesテーブルからnameが山田商店のレコード同士を連結します

customersとorders, ordersとitems, itemsとstoresが紐づきます。

first_nameとlast_nameの値を連結(CONCAT)して集計(GROUP BY)し、そのレコード数をCOUNTしてください。
*/

# answer (answerと同じ結果になった)
SELECT
    CONCAT(customers.last_name, customers.first_name) AS full_name,
    COUNT(*) AS record_count
FROM
    customers
    JOIN orders ON customers.id = orders.customer_id
    JOIN items ON orders.item_id = items.id
    JOIN stores ON items.store_id = stores.id
WHERE
    customers.last_name LIKE '%田%'
    AND orders.order_date >= '2020-12-01'
    AND stores.name = '山田商店'
GROUP BY
    full_name;

SELECT
	CONCAT(customers.last_name, customers.first_name), COUNT(*)
FROM
	(SELECT * FROM customers WHERE last_name LIKE '%田%') AS customers
	INNER JOIN (SELECT * FROM orders WHERE order_date >= "2020-12-01") AS orders
	ON customers.id = orders.customer_id
	INNER JOIN items
	ON orders.item_id = items.id
		INNER JOIN (SELECT * FROM stores WHERE name="山田商店") AS stores
		ON stores.id = items.store_id
		GROUP BY CONCAT(customers.last_name, customers.first_name);

/*
7. salariesのpaymentが9,000,000よりも大きいものが存在するレコードを、employeesテーブルから取り出してください。

employeesテーブルとsalariesテーブルを紐づけます。

EXISTSとINとINNER JOIN、それぞれの方法で記載してください
*/

# my answer EXISTS (answer EXISTSと同じ結果)
SELECT *
FROM employees e
WHERE EXISTS (
	SELECT 1
	FROM salaries s
	WHERE e.id = s.employee_id AND s.payment > 9000000
);

# answer EXISTS
SELECT * FROM employees AS emp
WHERE
	EXISTS(
		SELECT
			1
		FROM
			salaries AS sa
		WHERE emp.id = sa.employee_id AND sa.payment > 9000000
	);

# my answer IN (answer INと同じ結果)
SELECT *
FROM employees
WHERE id IN (
	SELECT employee_id
	FROM salaries
	WHERE payment > 9000000
);

# answer IN
SELECT * FROM employees
	WHERE id IN(SELECT employee_id FROM salaries WHERE payment > 9000000);

# my answer INNER JOIN (answer INNER JOINと同じ結果になる)
SELECT DISTINCT
    e.id,
    e.first_name,
    e.last_name,
    e.age,
    e.manager_id,
    e.department_id
FROM
    employees e
    INNER JOIN salaries s ON e.id = s.employee_id
WHERE
    s.payment > 9000000
    OR s.payment IS NULL;

# answer INNER JOIN
SELECT DISTINCT emp.* FROM employees AS emp
INNER JOIN salaries AS sa
ON emp.id = sa.employee_id
WHERE sa.payment  > 9000000;

/*
8. employeesテーブルから、salariesテーブルと紐づけのできないレコードを取り出してください。

EXISTSとINとLEFT JOIN、それぞれの方法で記載してください
*/

# my answer EXISTS (answer EXISTSと同じ結果)
SELECT *
FROM employees AS emp
WHERE NOT EXISTS (
	SELECT 1
	FROM salaries AS sa
	WHERE emp.id = sa.employee_id
);

# answer EXISTS
SELECT * FROM employees AS emp
WHERE
	NOT EXISTS(
		SELECT
			1
		FROM
			salaries AS sa
		WHERE sa.employee_id = emp.id
	);

# my answer IN (answer INと同じ結果になる)
SELECT *
FROM employees AS emp
WHERE emp.id NOT IN (
	SELECT employee_id
	FROM salaries
	WHERE employee_id IS NOT NULL
);

# answer IN
SELECT *
FROM employees
WHERE id NOT IN(SELECT employee_id FROM salaries);

# my answer LEFT JOIN (answer LEFT JOINと結果は同じ)
SELECT emp.*, NULL AS salary_id, NULL AS employee_id, NULL AS payment, NULL AS paid_date
FROM employees AS emp
LEFT JOIN salaries AS sa ON emp.id = sa.employee_id
WHERE sa.employee_id IS NULL;

# answer LEFT JOIN
SELECT * FROM employees AS emp
LEFT JOIN salaries AS sa
ON emp.id = sa.employee_id
WHERE sa.id IS NULL;

/*
9. employeesテーブルとcustomersテーブルのage同士を比較します

customersテーブルの最小age, 平均age, 最大ageとemployeesテーブルのageを比較して、

employeesテーブルのageが、最小age未満のものは最小未満、最小age以上で平均age未満のものは平均未満、

平均age以上で最大age未満のものは最大未満、それ以外はその他と表示します

WITH句を用いて記述します。
*/

# my answer (answerと同じ結果になる)
WITH age_comparison AS (
    SELECT
        MIN(age) AS min_age_customer,
        AVG(age) AS avg_age_customer,
        MAX(age) AS max_age_customer
    FROM
    customers
)
SELECT
    emp.*,
        ac.min_age_customer,
        ac.avg_age_customer,
        ac.max_age_customer,
    CASE
        WHEN emp.age < ac.min_age_customer THEN '最小未満'
        WHEN emp.age < ac.avg_age_customer THEN '平均未満'
        WHEN emp.age < ac.max_age_customer THEN '最大未満'
    ELSE 'その他'
    END AS age_category
FROM
    employees AS emp
CROSS JOIN age_comparison AS ac;

# answer
WITH customers_age AS(
    SELECT MAX(age) AS max_age, MIN(age) AS min_age, AVG(age) AS avg_age
    FROM customers
)
SELECT
    *,
    CASE
        WHEN emp.age < ca.min_age THEN "最小未満"
        WHEN emp.age < ca.avg_age THEN "平均未満"
        WHEN emp.age < ca.max_age THEN "最大未満"
        ELSE "その他"
    END AS "customersとの比較"
FROM
    employees AS emp
CROSS JOIN customers_age AS ca;

/*
10. customersテーブルからageが50よりも大きいレコードを取り出して、ordersテーブルと連結します。

customersテーブルのidに対して、ordersテーブルのorder_amount*order_priceのorder_date毎の合計値。

合計値の7日間平均値、合計値の15日平均値、合計値の30日平均値を計算します。

7日間平均、15日平均値、30日平均値が計算できない区間(対象よりも前の日付のデータが十分にない区間)は、空白を表示してください。
*/

# answer
WITH tmp_customers AS(
    SELECT
        *
    FROM
        customers
    WHERE
        age > 50
), tmp_customers_orders AS(
    SELECT
        tc.id, od.order_date, SUM(od.order_amount * od.order_price) AS payment,
        ROW_NUMBER() OVER(PARTITION BY tc.id ORDER BY od.order_date) AS row_num
    FROM tmp_customers AS tc
    INNER JOIN orders AS od
    ON tc.id = od.customer_id
    GROUP BY tc.id, od.order_date
)
SELECT id, order_date, payment,
CASE
    WHEN row_num < 7 THEN ""
    ELSE AVG(payment) OVER(PARTITION BY id ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
END AS "7日間平均",
CASE
    WHEN row_num < 15 THEN ""
    ELSE AVG(payment) OVER(PARTITION BY id ORDER BY order_date ROWS BETWEEN 14 PRECEDING AND CURRENT ROW)
END AS "15日間平均",
CASE
    WHEN row_num < 30 THEN ""
    ELSE AVG(payment) OVER(PARTITION BY id ORDER BY order_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW)
END AS "30日間平均"
FROM tmp_customers_orders;

