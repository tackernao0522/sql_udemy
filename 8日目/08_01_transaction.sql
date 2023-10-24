SHOW DATABASES;

USE day_4_9_db;

SHOW TABLES;

SELECT * FROM users;

-- TRANSACTIONの開始
START TRANSACTION;

-- UPDATE処理
UPDATE users SET name="中山 成美" WHERE id=1;

SELECT * FROM users;

-- ROLLBACK(トランザクション開始前に戻す)
ROLLBACK;

-- COMMIT(トランザクションをDBに反映)
COMMIT;