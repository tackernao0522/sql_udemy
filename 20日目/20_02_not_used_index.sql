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
