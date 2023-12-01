SELECT
	*
FROM customers AS ct
INNER JOIN prefectures AS pr
ON ct.prefecture_code = pr.prefecture_code;

EXPLAIN ANALYZE SELECT
	*
FROM customers AS ct
INNER JOIN prefectures AS pr
ON ct.prefecture_code = pr.prefecture_code;

/*
-> Nested loop inner join  (cost=224749 rows=497786) (actual time=0.138..1697 rows=500000 loops=1)
    -> Filter: (ct.prefecture_code is not null)  (cost=50524 rows=497786) (actual time=0.11..608 rows=500000 loops=1)
        -> Table scan on ct  (cost=50524 rows=497786) (actual time=0.109..528 rows=500000 loops=1)
    -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=0.00183..0.00188 rows=1 loops=500000)
*/

EXPLAIN ANALYZE SELECT /*+ NO_INDEX(pr)*/
	*
FROM customers AS ct
INNER JOIN prefectures AS pr
ON ct.prefecture_code = pr.prefecture_code;

/*
-> Inner hash join (ct.prefecture_code = pr.prefecture_code)  (cost=2.34e+6 rows=2.34e+6) (actual time=0.161..703 rows=500000 loops=1)
    -> Table scan on ct  (cost=122 rows=497786) (actual time=0.0632..487 rows=500000 loops=1)
    -> Hash
        -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.0456..0.0583 rows=47 loops=1)
*/
