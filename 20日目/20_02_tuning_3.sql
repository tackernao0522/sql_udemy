-- 無駄なGROUP BY
EXPLAIN ANALYZE SELECT
age, COUNT(*)
FROM customers
GROUP BY age;
/*
-> Table scan on <temporary>  (actual time=391..391 rows=49 loops=1)
    -> Aggregate using temporary table  (actual time=391..391 rows=49 loops=1)
        -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.129..231 rows=500000 loops=1)
*/

EXPLAIN ANALYZE SELECT
age, COUNT(*)
FROM customers
GROUP BY age
HAVING age<30;
/*
-> Filter: (customers.age < 30)  (actual time=389..390 rows=8 loops=1)
    -> Table scan on <temporary>  (actual time=389..389 rows=49 loops=1)
        -> Aggregate using temporary table  (actual time=389..389 rows=49 loops=1)
            -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.103..232 rows=500000 loops=1)
*/

-- 多少速くなっているがそんなに変わらない
EXPLAIN ANALYZE SELECT
age, COUNT(*)
FROM customers
WHERE age < 30
GROUP BY age;
/*
-> Table scan on <temporary>  (actual time=311..311 rows=8 loops=1)
    -> Aggregate using temporary table  (actual time=311..311 rows=8 loops=1)
        -> Filter: (customers.age < 30)  (cost=50524 rows=165912) (actual time=0.0977..279 rows=82096 loops=1)
            -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0915..225 rows=500000 loops=1)
*/

-- 速くなる
CREATE INDEX idx_customers_age ON customers(age);

EXPLAIN ANALYZE SELECT
age, COUNT(*)
FROM customers
WHERE age < 30
GROUP BY age;
/*
-> Group aggregate: count(0)  (cost=48687 rows=47) (actual time=7.37..68.7 rows=8 loops=1)
    -> Filter: (customers.age < 30)  (cost=32491 rows=161958) (actual time=0.0321..60 rows=82096 loops=1)
        -> Covering index range scan on customers using idx_customers_age over (NULL < age < 30)  (cost=32491 rows=161958) (actual time=0.0308..47.3 rows=82096 loops=1)
*/

-- MAX, MINはインデックスを利用する
EXPLAIN ANALYZE SELECT MAX(age), MIN(age) FROM customers;
/*
-> Rows fetched before execution  (cost=0..0 rows=1) (actual time=279e-6..354e-6 rows=1 loops=1)
*/

-- AVERAGEはINDEXを使えない
EXPLAIN ANALYZE SELECT MAX(age), MIN(age), AVG(age) FROM customers;
/*
-> Aggregate: avg(customers.age)  (cost=100302 rows=1) (actual time=240..240 rows=1 loops=1)
    -> Covering index scan on customers using idx_customers_age  (cost=50524 rows=497786) (actual time=0.0238..169 rows=500000 loops=1)
*/

-- SUMもINDEXは使えない
EXPLAIN ANALYZE SELECT MAX(age), MIN(age), AVG(age), SUM(age) FROM customers;
/*
-> Aggregate: avg(customers.age), sum(customers.age)  (cost=100302 rows=1) (actual time=265..265 rows=1 loops=1)
    -> Covering index scan on customers using idx_customers_age  (cost=50524 rows=497786) (actual time=0.0458..162 rows=500000 loops=1)
*/

-- DISTINCTの代わりにEXISTSを使用する
SELECT pr.name FROM prefectures AS pr
INNER JOIN customers AS ct
ON pr.prefecture_code  = ct.prefecture_code;

-- このパターンのDISTINCTは処理が重くなってしまう
EXPLAIN ANALYZE SELECT DISTINCT pr.name FROM prefectures AS pr
INNER JOIN customers AS ct
ON pr.prefecture_code  = ct.prefecture_code;
/*
-> Table scan on <temporary>  (cost=274527..280752 rows=497786) (actual time=2014..2014 rows=41 loops=1)
    -> Temporary table with deduplication  (cost=274527..274527 rows=497786) (actual time=2014..2014 rows=41 loops=1)
        -> Nested loop inner join  (cost=224749 rows=497786) (actual time=0.0872..1577 rows=500000 loops=1)
            -> Filter: (ct.prefecture_code is not null)  (cost=50524 rows=497786) (actual time=0.069..405 rows=500000 loops=1)
                -> Table scan on ct  (cost=50524 rows=497786) (actual time=0.0676..320 rows=500000 loops=1)
            -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=0.00199..0.00204 rows=1 loops=500000)
*/

-- EXISTS 速くなる
EXPLAIN ANALYZE SELECT name FROM prefectures AS pr
WHERE EXISTS(
	SELECT 1 FROM customers AS ct WHERE ct.prefecture_code = pr.prefecture_code 
);
/*
-> Nested loop inner join  (cost=2.34e+6 rows=23.4e+6) (actual time=487..487 rows=41 loops=1)
    -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.0607..0.0773 rows=47 loops=1)
    -> Single-row index lookup on <subquery2> using <auto_distinct_key> (prefecture_code=pr.prefecture_code)  (cost=100302..100302 rows=1) (actual time=10.4..10.4 rows=0.872 loops=47)
        -> Materialize with deduplication  (cost=100302..100302 rows=497786) (actual time=487..487 rows=41 loops=1)
            -> Filter: (ct.prefecture_code is not null)  (cost=50524 rows=497786) (actual time=0.118..330 rows=500000 loops=1)
                -> Table scan on ct  (cost=50524 rows=497786) (actual time=0.116..264 rows=500000 loops=1)
*/

-- UNION -> UNION ALL
EXPLAIN ANALYZE
SELECT * FROM customers WHERE age<30
UNION
SELECT * FROM customers c WHERE age>50;
/*
-> Table scan on <union temporary>  (cost=142132..147270 rows=410851) (actual time=3375..3679 rows=286055 loops=1)
    -> Union materialize with deduplication  (cost=142132..142132 rows=410851) (actual time=3374..3374 rows=286055 loops=1)
        -> Filter: (customers.age < 30)  (cost=50524 rows=161958) (actual time=0.0767..535 rows=82096 loops=1)
            -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0719..477 rows=500000 loops=1)
        -> Filter: (c.age > 50)  (cost=50524 rows=248893) (actual time=0.0861..616 rows=203959 loops=1)
            -> Table scan on c  (cost=50524 rows=497786) (actual time=0.0836..534 rows=500000 loops=1)
*/

EXPLAIN ANALYZE
SELECT * FROM customers WHERE age<30
UNION ALL
SELECT * FROM customers c WHERE age>50;
/*
 -> Append  (cost=103098 rows=410851) (actual time=2.03..1355 rows=286055 loops=1)
    -> Stream results  (cost=51549 rows=161958) (actual time=2.03..673 rows=82096 loops=1)
        -> Filter: (customers.age < 30)  (cost=51549 rows=161958) (actual time=2.02..600 rows=82096 loops=1)
            -> Table scan on customers  (cost=51549 rows=497786) (actual time=2.01..547 rows=500000 loops=1)
    -> Stream results  (cost=51549 rows=248893) (actual time=0.0729..649 rows=203959 loops=1)
        -> Filter: (c.age > 50)  (cost=51549 rows=248893) (actual time=0.0683..494 rows=203959 loops=1)
            -> Table scan on c  (cost=51549 rows=497786) (actual time=0.0661..436 rows=500000 loops=1)
*/

