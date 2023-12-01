EXPLAIN ANALYZE SELECT * FROM customers;

/*
-> Table scan on customers  (cost=50524 rows=497786) (actual time=0.116..474 rows=500000 loops=1)
*/

EXPLAIN ANALYZE SELECT * FROM customers WHERE id=1;

/*
-> Rows fetched before execution  (cost=0..0 rows=1) (actual time=513e-6..582e-6 rows=1 loops=1)
*/

EXPLAIN SELECT * FROM customers WHERE id=1;

/*
id|select_type|table    |partitions|type |possible_keys|key    |key_len|ref  |rows|filtered|Extra|
--+-----------+---------+----------+-----+-------------+-------+-------+-----+----+--------+-----+
 1|SIMPLE     |customers|          |const|PRIMARY      |PRIMARY|3      |const|   1|   100.0|     |
*/


EXPLAIN SELECT * FROM customers WHERE id<10;

/*
id|select_type|table    |partitions|type |possible_keys|key    |key_len|ref|rows|filtered|Extra      |
--+-----------+---------+----------+-----+-------------+-------+-------+---+----+--------+-----------+
 1|SIMPLE     |customers|          |range|PRIMARY      |PRIMARY|3      |   |   9|   100.0|Using where|
*/

EXPLAIN ANALYZE SELECT * FROM customers WHERE id<10;

/*
-> Filter: (customers.id < 10)  (cost=2.06 rows=9) (actual time=2.28..2.34 rows=9 loops=1)
    -> Index range scan on customers using PRIMARY over (id < 10)  (cost=2.06 rows=9) (actual time=0.0278..0.0838 rows=9 loops=1)
*/

SELECT * FROM customers WHERE first_name="Olivia"; -- 486ms

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name="Olivia";

/*
-> Filter: (customers.first_name = 'Olivia')  (cost=50524 rows=49779) (actual time=0.137..735 rows=503 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.133..629 rows=500000 loops=1)
*/

CREATE INDEX idx_customers_first_name ON customers(first_name);

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name="Olivia";

/*
-> Index lookup on customers using idx_customer_first_name (first_name='Olivia')  (cost=176 rows=503) (actual time=1.15..5.15 rows=503 loops=1)
*/

SELECT * FROM customers;

SELECT * FROM customers WHERE gender="F";

EXPLAIN ANALYZE SELECT * FROM customers WHERE gender="F";

/*
-> Filter: (customers.gender = 'F')  (cost=50524 rows=49779) (actual time=0.0884..566 rows=250065 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0843..466 rows=500000 loops=1)
*/

-- インデックスをつけると遅くなるパターン(genderは FかMしかないので)
CREATE INDEX idx_customers_gender ON customers(gender);

EXPLAIN ANALYZE SELECT * FROM customers WHERE gender="F";

/*
-> Index lookup on customers using idx_customers_gender (gender='F'), with index condition: (customers.gender = 'F')  (cost=27124 rows=248893) (actual time=0.326..1343 rows=250065 loops=1)
*/

-- ヒント句をつけると若干速くなる(あまり使われない ちゃんと反映されないこともある)
EXPLAIN ANALYZE SELECT /*+ NO_INDEX(ct) */* FROM customers AS ct WHERE ct.gender="F"; -- ctに対してINDEXを使うなという命令

/*
-> Filter: (ct.gender = 'F')  (cost=50524 rows=497786) (actual time=0.101..610 rows=250065 loops=1)
    -> Table scan on ct  (cost=50524 rows=497786) (actual time=0.096..499 rows=500000 loops=1)
*/

-- INDEXの削除
DROP INDEX idx_customers_gender ON customers;
DROP INDEX idx_customers_first_name ON customers;
