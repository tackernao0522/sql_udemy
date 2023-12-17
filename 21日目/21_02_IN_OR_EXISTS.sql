USE day_19_21_db;

SELECT COUNT(*) FROM prefectures;

SELECT COUNT(*) FROM customers;

CREATE INDEX idx_customers_prefecture_code ON customers(prefecture_code);

-- prefuctures < customers

-- EXISTS
EXPLAIN ANALYZE
SELECT * FROM prefectures AS pr
WHERE EXISTS (SELECT 1 FROM customers AS ct WHERE pr.prefecture_code = ct.prefecture_code);
/*
-> Nested loop semijoin  (cost=56572 rows=557046) (actual time=0.231..4.7 rows=41 loops=1)
    -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.0724..0.129 rows=47 loops=1)
    -> Covering index lookup on ct using idx_customers_prefecture_code (prefecture_code=pr.prefecture_code)  (cost=516377 rows=11852) (actual time=0.0963..0.0963 rows=0.872 loops=47)
*/

-- IN
EXPLAIN ANALYZE
SELECT * FROM prefectures AS pr
WHERE prefecture_code IN (SELECT prefecture_code FROM customers);
/*
-> Nested loop semijoin  (cost=56572 rows=557046) (actual time=0.105..1.97 rows=41 loops=1)
    -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.0422..0.0741 rows=47 loops=1)
    -> Covering index lookup on customers using idx_customers_prefecture_code (prefecture_code=pr.prefecture_code)  (cost=516377 rows=11852) (actual time=0.0401..0.0401 rows=0.872 loops=47)
*/
