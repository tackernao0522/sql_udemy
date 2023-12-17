USE day_19_21_db;

SHOW INDEX FROM customers;

DROP INDEX idx_customers_age ON customers;

SELECT
*
FROM customers
WHERE
prefecture_code IN (SELECT prefecture_code FROM prefectures WHERE name="東京都")
OR
prefecture_code IN (SELECT prefecture_code FROM prefectures WHERE name="大阪府")
;

-- 無駄な処理を1つに
SELECT
*
FROM customers
WHERE
prefecture_code IN (SELECT prefecture_code FROM prefectures WHERE name IN ("東京都", "大阪府"))
;

-- SELECT内副問い合わせをやめる
EXPLAIN ANALYZE
SELECT
*, (SELECT name FROM prefectures AS pr WHERE pr.prefecture_code = ct.prefecture_code)
FROM customers AS ct
;
/*
-> Table scan on ct  (cost=50524 rows=497786) (actual time=0.123..561 rows=500000 loops=1)
-> Select #2 (subquery in projection; dependent)
    -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.35 rows=1) (actual time=0.00262..0.00268 rows=1 loops=500000)
*/

EXPLAIN ANALYZE
SELECT
*, pr.name
FROM customers AS ct
LEFT JOIN
prefectures AS pr
ON pr.prefecture_code = ct.prefecture_code
;
/*
-> Nested loop left join  (cost=224749 rows=497786) (actual time=0.148..1625 rows=500000 loops=1)
    -> Table scan on ct  (cost=50524 rows=497786) (actual time=0.116..552 rows=500000 loops=1)
    -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=0.00179..0.00185 rows=1 loops=500000)
*/

SHOW TABLES;

-- 2016年度、2016年度の月ごとの集計カラムを追加
SELECT * FROM sales_history;
