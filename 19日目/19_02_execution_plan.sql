SHOW DATABASES;

CREATE DATABASE day_19_21_db;

USE day_19_21_db;

SHOW TABLES;

-- 統計情報の確認
SELECT * FROM mysql.innodb_table_stats WHERE database_name="day_19_21_db";

SELECT * FROM prefectures;

INSERT INTO prefectures VALUES("48", "不明");

-- 統計情報の手動更新
ANALYZE TABLE prefectures;

SELECT * FROM mysql.innodb_table_stats WHERE database_name="day_19_21_db"; -- 48件になる

DELETE FROM prefectures WHERE prefecture_code="48" AND name = "不明";

ANALYZE TABLE prefectures;

SELECT * FROM mysql.innodb_table_stats WHERE database_name="day_19_21_db"; -- 47件になる

-- SQLを実行せずに実行計画だけ表示
EXPLAIN SELECT * FROM customers;

-- SQLを実行して、実行計画を表示
EXPLAIN ANALYZE SELECT * FROM customers;

/*
-> Table scan on customers  (cost=52750 rows=497786) (actual time=0.0823..536 rows=500000 loops=1)
*/

SELECT * FROM customers; -- SQLタブから実行計画を説明するをクリックすると表示される（他の方法)

