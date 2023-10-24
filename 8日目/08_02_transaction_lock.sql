SHOW DATABASES;
USE day_4_9_db;

START TRANSACTION;

SHOW TABLES;

SELECT * FROM customers;

-- 主キーでUPDATE(行ロック)
UPDATE customers SET age=43 WHERE id=1;

ROLLBACK;

START TRANSACTION;

-- テーブル全体のロック
UPDATE customers SET age=42
-- WHERE id=1;
WHERE name="河野 文典";

ROLLBACK;

-- DELETE
START TRANSACTION;

-- 行ロック
DELETE FROM customers WHERE id=1;

COMMIT;

-- INSERT
START TRANSACTION;

INSERT INTO customers VALUES(1, "田中 一郎", 21, '1999-10-01');
SELECT * FROM customers;

COMMIT;

-- SELECTのロック
-- FOR SHARE(共有ロック)
-- FOR UPDATE(排他ロック)

START TRANSACTION;

SELECT * FROM customers WHERE id="1" FOR SHARE;

ROLLBACK;

START TRANSACTION;
SELECT * FROM customers WHERE id=1 FOR UPDATE;
ROLLBACK;

/*
＃ 明示的にテーブルをロックする
明示的にトランザクション以外にもテーブルをロックするコマンドが存在する
*/

# LOCK TABLE テーブル名 READ
/*
・実行したセッションは、テーブルを読み込むことができるが、書き込むことはできない
・他のセッションも、テーブルを読み込むことはできるが、書き込むことはできない

LOCK TABLE table READ
*/

LOCK TABLE customers READ;
SELECT * FROM customers;
UPDATE customers SET age=42 WHERE id=1; -- 更新不可

# LOCKを解除する
UNLOCK TABLES;

# LOCK TABLE テーブル名 WRITE
/*
・実行したセッションは、テーブルを読み込むことも書き込むこともできる
・他のセッションは、テーブルを読みことも書き込むことはできない

LOCK TABLE tabe WRITE
*/
LOCK TABLE customers WRITE ;
UPDATE customers SET age=42 WHERE id=1;

# UNLOCK TABLES
/*
現セッションの保有するテーブルロックを全て解除する
*/

UNLOCK TABLES;

# デッドロック
/*
2つのセッションが互いの更新対象のテーブルをロックしていて、処理が進まない状態のこと
*/

START TRANSACTION;
-- customers -> users (この順で更新する 他セッションはこの逆でやってみる)
UPDATE customers SET age=42 WHERE id=1;

UPDATE users SET age=12 WHERE id=1;

# アプリケーションでのトランザクション処理
/*
アプリケーションで、トランザクションのコードを記述することで、トランザクションを実行することができる

Laravelの場合
DB::beginTransaction();
try {
	$user->fill($request->all();)->save();
	DB::commit();
} catch (\Exception $e) {
	DB::rollback();
}
*/
