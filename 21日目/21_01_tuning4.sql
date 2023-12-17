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

-- 2016年度、2016年度の日ごとの集計カラムを追加
SELECT sales_day,SUM(sales_amount)
FROM sales_history
WHERE sales_day BETWEEN '2016-01-01' AND '2016-12-31' GROUP BY sales_day;

EXPLAIN ANALYZE
SELECT
	sales_history.*, sales_summary.sales_daily_amount
FROM
	sales_history
LEFT JOIN
(SELECT sales_day,SUM(sales_amount) AS sales_daily_amount
FROM sales_history
WHERE sales_day BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY sales_day) AS sales_summary
ON sales_history.sales_day = sales_summary.sales_day
WHERE sales_history.sales_day BETWEEN '2016-01-01' AND '2016-12-31';
/*
-> Nested loop left join  (cost=943850 rows=0) (actual time=2559..5695 rows=312844 loops=1)
    -> Filter: (sales_history.sales_day between '2016-01-01' and '2016-12-31')  (cost=250914 rows=277172) (actual time=0.101..2657 rows=312844 loops=1)
        -> Table scan on sales_history  (cost=250914 rows=2.49e+6) (actual time=0.0971..1505 rows=2.5e+6 loops=1)
    -> Index lookup on sales_summary using <auto_key0> (sales_day=sales_history.sales_day)  (cost=0.25..2.5 rows=10) (actual time=0.00914..0.00939 rows=1 loops=312844)
        -> Materialize  (cost=0..0 rows=0) (actual time=2558..2558 rows=336 loops=1)
            -> Table scan on <temporary>  (actual time=2558..2558 rows=336 loops=1)
                -> Aggregate using temporary table  (actual time=2558..2558 rows=336 loops=1)
                    -> Filter: (sales_history.sales_day between '2016-01-01' and '2016-12-31')  (cost=250914 rows=277172) (actual time=0.0637..2262 rows=312844 loops=1)
                        -> Table scan on sales_history  (cost=250914 rows=2.49e+6) (actual time=0.0613..1150 rows=2.5e+6 loops=1)
*/

EXPLAIN ANALYZE
SELECT
	sh.*, SUM(sh.sales_amount) OVER(PARTITION BY sh.sales_day)
FROM
	sales_history AS sh
WHERE sh.sales_day BETWEEN '2016-01-01' AND '2016-12-31';
/*
-> Window aggregate with buffering: sum(sales_history.sales_amount) OVER (PARTITION BY sh.sales_day )   (actual time=2611..3090 rows=312844 loops=1)
    -> Sort: sh.sales_day  (cost=250914 rows=2.49e+6) (actual time=2608..2657 rows=312844 loops=1)
        -> Filter: (sh.sales_day between '2016-01-01' and '2016-12-31')  (cost=250914 rows=2.49e+6) (actual time=0.0793..2420 rows=312844 loops=1)
            -> Table scan on sh  (cost=250914 rows=2.49e+6) (actual time=0.074..1329 rows=2.5e+6 loops=1)
*/
