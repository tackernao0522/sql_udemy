USE day_19_21_db;

SELECT * FROM customers;

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name="Olivia";
/*
-> Limit: 200 row(s)  (cost=50524 rows=200) (actual time=0.133..319 rows=200 loops=1)
    -> Filter: (customers.first_name = 'Olivia')  (cost=50524 rows=49779) (actual time=0.129..319 rows=200 loops=1)
        -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.123..272 rows=192550 loops=1)
*/

-- first_nameにINDEXと追加
CREATE INDEX idx_customers_first_name ON customers(first_name);

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name="Olivia";
/*
 -> Limit: 200 row(s)  (cost=176 rows=200) (actual time=0.466..1.42 rows=200 loops=1)
    -> Index lookup on customers using idx_customers_first_name (first_name='Olivia')  (cost=176 rows=503) (actual time=0.465..1.4 rows=200 loops=1)
*/

EXPLAIN ANALYZE SELECT * FROM customers WHERE age=41;
/*
-> Limit: 200 row(s)  (cost=50524 rows=200) (actual time=0.104..10.8 rows=200 loops=1)
    -> Filter: (customers.age = 41)  (cost=50524 rows=49779) (actual time=0.103..10.7 rows=200 loops=1)
        -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.083..9.72 rows=10108 loops=1)
*/

CREATE INDEX idx_customers_age ON customers(age);

EXPLAIN ANALYZE SELECT * FROM customers WHERE age=41;
/*
-> Limit: 200 row(s)  (cost=3245 rows=200) (actual time=0.655..1.73 rows=200 loops=1)
    -> Index lookup on customers using idx_customers_age (age=41)  (cost=3245 rows=10100) (actual time=0.654..1.7 rows=200 loops=1)
*/

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name="Olivia" AND age=42;
/*
-> Limit: 200 row(s)  (cost=35.6 rows=10) (actual time=0.533..8.72 rows=10 loops=1)
    -> Filter: ((customers.age = 42) and (customers.first_name = 'Olivia'))  (cost=35.6 rows=10) (actual time=0.532..8.71 rows=10 loops=1)
        -> Intersect rows sorted by row ID  (cost=35.6 rows=10.2) (actual time=0.526..8.67 rows=10 loops=1)
            -> Index range scan on customers using idx_customers_first_name over (first_name = 'Olivia')  (cost=24.9 rows=503) (actual time=0.0744..0.7 rows=503 loops=1)
            -> Index range scan on customers using idx_customers_age over (age = 42)  (cost=7.15 rows=10086) (actual time=0.0224..6.42 rows=10082 loops=1)
*/

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name="Olivia" OR age=42;
/*
-> Limit: 200 row(s)  (cost=114714 rows=200) (actual time=0.109..18.2 rows=200 loops=1)
    -> Filter: ((customers.first_name = 'Olivia') or (customers.age = 42))  (cost=114714 rows=94579) (actual time=0.108..18.2 rows=200 loops=1)
        -> Table scan on customers  (cost=114714 rows=497786) (actual time=0.104..15.4 rows=10275 loops=1)
*/

-- 複合インデックス
DROP INDEX idx_customers_first_name ON customers;
DROP INDEX idx_customers_age ON customers;

CREATE INDEX idx_customers_first_name_age ON customers(first_name, age);

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name="Olivia" AND age=42;
/*
-> Limit: 200 row(s)  (cost=3.5 rows=10) (actual time=0.0992..0.106 rows=10 loops=1)
    -> Index lookup on customers using idx_customers_first_name_age (first_name='Olivia', age=42)  (cost=3.5 rows=10) (actual time=0.0983..0.105 rows=10 loops=1)
*/

-- ageだけはFULL SCAN
EXPLAIN ANALYZE SELECT * FROM customers WHERE age=51; -- ageだけに絞り込んだ場合インデックスを使えない
/*
-> Limit: 200 row(s)  (cost=50524 rows=200) (actual time=0.0933..10.9 rows=200 loops=1)
    -> Filter: (customers.age = 51)  (cost=50524 rows=49779) (actual time=0.0925..10.8 rows=200 loops=1)
        -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0818..9.89 rows=10706 loops=1)
*/

-- ORの場合もFULL SCAN
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name="Olivia" OR age=42;
/*
-> Limit: 200 row(s)  (cost=50524 rows=200) (actual time=0.13..14.7 rows=200 loops=1)
    -> Filter: ((customers.first_name = 'Olivia') or (customers.age = 42))  (cost=50524 rows=50331) (actual time=0.129..14.7 rows=200 loops=1)
        -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.123..10.9 rows=10275 loops=1)
*/

-- ORDER BY, GROUP BY: 処理時間かかる、実行の前にWHEREで絞り込む
DROP INDEX idx_customers_first_name_age ON customers;

EXPLAIN ANALYZE SELECT * FROM customers ORDER BY first_name;
/*
-> Sort: customers.first_name  (cost=50524 rows=497786) (actual time=1204..1380 rows=500000 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0851..468 rows=500000 loops=1)
*/

-- INDEXあり
CREATE INDEX idx_customers_first_name ON customers(first_name);

EXPLAIN ANALYZE SELECT * FROM customers ORDER BY first_name;
/*
-> Sort: customers.first_name  (cost=50524 rows=497786) (actual time=1155..1344 rows=500000 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0861..464 rows=500000 loops=1)
*/

-- 強制的にINDEXを使用する
EXPLAIN ANALYZE SELECT /*+ INDEX(customers)*/* FROM customers ORDER BY first_name;
/*
-> Index scan on customers using idx_customers_first_name  (cost=174225 rows=497786) (actual time=0.334..1717 rows=500000 loops=1)
*/

EXPLAIN ANALYZE SELECT * FROM customers ORDER BY id; -- 一意のカラムに対してORDER BYで絞り込んでる場合は速い
/*
-> Index scan on customers using PRIMARY  (cost=50524 rows=497786) (actual time=0.121..463 rows=500000 loops=1)
*/

-- GROUP BY
EXPLAIN ANALYZE SELECT first_name,COUNT(*)  FROM customers GROUP BY first_name;
/*
-> Group aggregate: count(0)  (cost=100302 rows=569) (actual time=2.04..330 rows=690 loops=1)
    -> Covering index scan on customers using idx_customers_first_name  (cost=50524 rows=497786) (actual time=0.0747..214 rows=500000 loops=1)
*/

-- ageに対してFULL SCAN
EXPLAIN ANALYZE SELECT age,COUNT(*) FROM customers GROUP BY age;
/*
-> Table scan on <temporary>  (actual time=383..383 rows=49 loops=1)
    -> Aggregate using temporary table  (actual time=383..383 rows=49 loops=1)
        -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0638..226 rows=500000 loops=1)
*/

-- ageに対してINDEXを貼る
CREATE INDEX idx_customers_age ON customers(age);

EXPLAIN ANALYZE SELECT age,COUNT(*) FROM customers GROUP BY age;
/*
 -> Group aggregate: count(0)  (cost=100302 rows=50) (actual time=4.83..249 rows=49 loops=1)
    -> Covering index scan on customers using idx_customers_age  (cost=50524 rows=497786) (actual time=0.103..201 rows=500000 loops=1)
*/

DROP INDEX idx_customers_first_name ON customers;
DROP INDEX idx_customers_age ON customers;

-- 複数のGROUP BY
CREATE INDEX idx_customers_first_name_age ON customers(first_name, age);

EXPLAIN ANALYZE SELECT first_name, age,COUNT(*) FROM customers GROUP BY first_name, age;
/*
 -> Group aggregate: count(0)  (cost=100302 rows=15741) (actual time=0.11..381 rows=32369 loops=1)
    -> Covering index scan on customers using idx_customers_first_name_age  (cost=50524 rows=497786) (actual time=0.0916..247 rows=500000 loops=1)
*/

DROP INDEX idx_customers_first_name_age ON customers;

-- 外部キーにインデックス
SELECT * FROM prefectures AS pr
INNER JOIN customers AS ct
ON pr.prefecture_code = ct.prefecture_code AND pr.name="北海道";

EXPLAIN ANALYZE SELECT * FROM prefectures AS pr
INNER JOIN customers AS ct
ON pr.prefecture_code = ct.prefecture_code AND pr.name="北海道";
/*
-> Nested loop inner join  (cost=224749 rows=49779) (actual time=0.201..2186 rows=12321 loops=1)
    -> Filter: (ct.prefecture_code is not null)  (cost=50524 rows=497786) (actual time=0.117..707 rows=500000 loops=1)
        -> Table scan on ct  (cost=50524 rows=497786) (actual time=0.115..632 rows=500000 loops=1)
    -> Filter: (pr.`name` = '北海道')  (cost=0.25 rows=0.1) (actual time=0.00274..0.00275 rows=0.0246 loops=500000)
        -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=0.00212..0.00217 rows=1 loops=500000)
*/

-- customersテーブルにインデックスを貼ってみる
CREATE INDEX idx_customers_prefecture_code ON customers(prefecture_code);

EXPLAIN ANALYZE SELECT * FROM prefectures AS pr
INNER JOIN customers AS ct
ON pr.prefecture_code = ct.prefecture_code AND pr.name="北海道";
/*
-> Nested loop inner join  (cost=16508 rows=59990) (actual time=0.592..72.8 rows=12321 loops=1)
    -> Filter: (pr.`name` = '北海道')  (cost=4.95 rows=4.7) (actual time=0.0741..0.0961 rows=1 loops=1)
        -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.0679..0.0796 rows=47 loops=1)
    -> Index lookup on ct using idx_customers_prefecture_code (prefecture_code=pr.prefecture_code)  (cost=2507 rows=12764) (actual time=0.515..71.3 rows=12321 loops=1)
*/

DROP INDEX idx_customers_prefecture_code ON customers;
