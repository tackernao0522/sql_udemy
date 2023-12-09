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
