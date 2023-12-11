-- INDEXなし
SELECT * FROM customers WHERE UPPER(first_name) = "JOSEPH";

-- INDEX追加(INDEXは無効化されてしまう)
CREATE INDEX idx_customers_first_name ON customers(first_name);

EXPLAIN ANALYZE SELECT * FROM customers WHERE UPPER(first_name) = "JOSEPH";
/*
-> Filter: (upper(customers.first_name) = 'JOSEPH')  (cost=50524 rows=497786) (actual time=0.102..566 rows=4712 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0925..448 rows=500000 loops=1)
*/

-- 関数INDEXを追加(INDEXは使われるが万能ではない)
CREATE INDEX idx_customers_lower_first_name ON customers((UPPER(first_name)));

EXPLAIN ANALYZE SELECT * FROM customers WHERE UPPER(first_name) = "JOSEPH";
/*
-> Index lookup on customers using idx_customers_lower_first_name (upper(first_name)='JOSEPH')  (cost=1649 rows=4712) (actual time=0.345..38.6 rows=4712 loops=1)
*/

-- INで調べた方が良い
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name IN("joseph", "Joseph", "JOSEPH");
/*
-> Index range scan on customers using idx_customers_first_name over (first_name = 'joseph'), with index condition: (customers.first_name in ('joseph','Joseph','JOSEPH'))  (cost=2121 rows=4712) (actual time=0.17..64.7 rows=4712 loops=1)
*/

DROP INDEX idx_customers_first_name ON customers;
DROP INDEX idx_customers_lower_first_name ON customers;

CREATE INDEX idx_customers_age ON customers(age);

EXPLAIN ANALYZE SELECT * FROM customers WHERE age=25; -- INDEXスキャンが使用されて速い
/*
-> Index lookup on customers using idx_customers_age (age=25)  (cost=3264 rows=10286) (actual time=0.942..142 rows=10286 loops=1)
*/

EXPLAIN ANALYZE SELECT * FROM customers WHERE age+2=27; -- FULL SCANになってしまう
/*
-> Filter: ((customers.age + 2) = 27)  (cost=50524 rows=497786) (actual time=0.107..510 rows=10286 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0832..455 rows=500000 loops=1)
*/

-- 文字列と数値の比較(INDEXは使えない FULL SCANになる)
CREATE INDEX idx_customers_prefecture_code ON customers(prefecture_code);
EXPLAIN ANALYZE SELECT * FROM customers WHERE prefecture_code=21;
/*
-> Filter: (customers.prefecture_code = 21)  (cost=50524 rows=49779) (actual time=0.145..519 rows=12192 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.133..446 rows=500000 loops=1)
*/
DESCRIBE customers; -- prefecture_codeはchar型(文字列)である

EXPLAIN ANALYZE SELECT * FROM customers WHERE prefecture_code="21";
/*
 -> Index lookup on customers using idx_customers_prefecture_code (prefecture_code='21'), with index condition: (customers.prefecture_code = '21')  (cost=4429 rows=21942) (actual time=1.02..285 rows=12192 loops=1)
*/

-- 前方一致、中間一致、後方一致 前方一致はINDEXが使われる それ以外は使用されない
CREATE INDEX idx_customers_first_name ON customers(first_name);
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name LIKE 'Jo%';
/*
-> Index range scan on customers using idx_customers_first_name over ('Jo' <= first_name <= 'Jo􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿'), with index condition: (customers.first_name like 'Jo%')  (cost=23498 rows=52218) (actual time=0.0856..287 rows=24521 loops=1)
*/

-- 後方一致はフルスキャンになる
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name LIKE '%A';
/*
-> Filter: (customers.first_name like '%A')  (cost=50524 rows=55304) (actual time=0.108..594 rows=92504 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.105..463 rows=500000 loops=1)
*/

-- 中間一致はフルスキャン
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name LIKE "%Jo%";
/*
-> Filter: (customers.first_name like '%Jo%')  (cost=50524 rows=55304) (actual time=0.124..563 rows=24521 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.117..451 rows=500000 loops=1)
*/

-- 考えられる対策として
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name LIKE "%Jo%" LIMIT 50000; -- first_nameにJoを含む人の最初に50000件
/*
-> Limit: 50000 row(s)  (cost=50524 rows=50000) (actual time=2.64..590 rows=24521 loops=1)
    -> Filter: (customers.first_name like '%Jo%')  (cost=50524 rows=55304) (actual time=2.64..588 rows=24521 loops=1)
        -> Table scan on customers  (cost=50524 rows=497786) (actual time=2.63..467 rows=500000 loops=1)
*/

-- customersから50000件取ってきたうち、first_nameにJoを含む人
EXPLAIN ANALYZE SELECT * FROM (SELECT * FROM customers LIMIT 50000) AS tmp WHERE first_name LIKE "%Jo%"; -- 副問い合わせにする
/*
-> Filter: (tmp.first_name like '%Jo%')  (cost=55515..5628 rows=5555) (actual time=144..169 rows=2423 loops=1)
    -> Table scan on tmp  (cost=55524..56151 rows=50000) (actual time=144..158 rows=50000 loops=1)
        -> Materialize  (cost=55524..55524 rows=50000) (actual time=144..144 rows=50000 loops=1)
            -> Limit: 50000 row(s)  (cost=50524 rows=50000) (actual time=0.0894..70.4 rows=50000 loops=1)
                -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0887..64.5 rows=50000 loops=1)
*/

SHOW INDEX FROM customers;

DROP INDEX idx_customers_age ON customers;
DROP INDEX idx_customers_prefecture_code ON customers;
DROP INDEX idx_customers_first_name ON customers;
