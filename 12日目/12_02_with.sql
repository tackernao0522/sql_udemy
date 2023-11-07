/*
WITHとは
WITHの後に記述したSQLの実行結果を、一時的なテーブルに格納する。可読性の高い構文

```
WITH 中間テーブル名1 AS (
	SELECT ○○
), 中間テーブル名2 AS (
	SELECT ○○
)
SELECT *
FROM テーブル
INNER JOIN 中間テーブル1 ON テーブル.id = 中間テーブル1.id
INNER JOIN 中間テーブル2 ON 中間テーブル1.id = 中間テーブル2.id
```
MySQLでは、WITHはversion 8.0以降で利用できるようになった
*/

-- departmentsから営業部の人を取り出して、employeesと結合する
SELECT
*
FROM employees AS e
	INNER JOIN departments AS d
		ON e.department_id  = d.id
			WHERE d.name = "営業部";

WITH tmp_departments AS (
	SELECT * FROM departments WHERE name = "営業部"
)
SELECT * FROM employees AS e
	INNER JOIN tmp_departments
		ON e.department_id = tmp_departments.id;

-- storesテーブルからid 1,2,3の者を取り出す。(WHERE)
-- itemsテーブルと紐付け、itemsテーブルとordersテーブルを紐付ける。(INNER JOIN)
-- ordersテーブルのorder_abount*order_priceの合計値をstoresテーブルのstore_name毎に集計する(GROUP BY SUM)

WITH tmp_stores AS(
	SELECT * FROM stores WHERE id IN(1,2,3)
), tmp_items_orders AS(
	SELECT
		items.id AS item_id,
		tmp_stores.id AS store_id,
		orders.id AS order_id,
		orders.order_amount AS order_amount,
		orders.order_price AS order_price,
		tmp_stores.name AS store_name
			FROM tmp_stores
				INNER JOIN items
					ON tmp_stores.id = items.store_id
						INNER JOIN orders
							ON items.id = orders.item_id
						)
SELECT store_name, SUM(order_amount * order_price) FROM tmp_items_orders
	GROUP BY store_name;
