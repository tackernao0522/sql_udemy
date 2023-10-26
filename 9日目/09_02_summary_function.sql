SELECT * FROM customers WHERE name IS NULL;

-- COUNT
SELECT COUNT(*) FROM customers; -- 何行データが入っているか
SELECT COUNT(id) FROM customers; -- idは必ずあるので上記と同じ結果になる
SELECT COUNT(name) FROM customers; -- 列指定(この列に何行入っているか(NULLはカウントしない))

SELECT COUNT(name) FROM customers WHERE id>80;

SELECT * FROM customers;

SELECT MAX(age), MIN(age) FROM users;

-- MAX: 最大, MIN: 最小
SELECT MAX(age), MIN(age) FROM users WHERE birth_place ="日本";

SELECT MAX(birth_day), MIN(birth_day) FROM users;

-- SUM: 合計値
SELECT SUM(salary) FROM employees;

SELECT * FROM employees;

SELECT AVG(salary) FROM employees;

-- AVG: NULLの場合が面倒
CREATE TABLE temp_count(
	num INT
);

SHOW TABLES;

INSERT INTO temp_count VALUES(1);
INSERT INTO temp_count VALUES(2);
INSERT INTO temp_count VALUES(3);
INSERT INTO temp_count VALUES(NULL);

SELECT * FROM temp_count;

SELECT AVG(num) FROM temp_count;

SELECT AVG(COALESCE(num, 0)) FROM temp_count;

-- (1 + 2 + 3 + 0) / 4 = 1.5
