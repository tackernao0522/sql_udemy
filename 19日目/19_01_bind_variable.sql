USE day_10_14_db;

SHOW tables;

-- バインド変数(処理速度が速くなる)
SET @customer_id=7;
SELECT * FROM customers WHERE id = @customer_id;
