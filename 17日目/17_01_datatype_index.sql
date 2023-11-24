USE day_15_18_db;

CREATE TABLE messages(
	name_code CHAR(8), -- mysqlの場合はオートインクリメントは使えない
	name VARCHAR(25),
	message TEXT -- 65535文字まで可能
);

INSERT INTO messages VALUES("00000001", "Yoshida Takeshi", "aaaaba");
INSERT INTO messages VALUES("00000002", "Yoshida Yusaku", "aaaaba");

-- INT系
CREATE TABLE patients(
	id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- 0〜65535
	name VARCHAR(50),
	age TINYINT UNSIGNED DEFAULT 0 -- 0〜255
);

INSERT INTO patients(name, age) VALUES("Sachiko", 34);

SELECT * FROM patients;

INSERT INTO patients(name, age) VALUES("Sachiko", 434); -- 入らない
INSERT INTO patients(name, age) VALUES("Sachiko", 255); -- 入る

INSERT INTO patients(id, name) VALUES(65536, "Yoshio"); -- 入らない 65535まで

ALTER TABLE patients MODIFY id MEDIUMINT UNSIGNED AUTO_INCREMENT; -- 0〜16777215

SHOW FULL COLUMNS FROM patients;

-- heightカラム、weightカラムの追加
ALTER TABLE patients ADD COLUMN(height FLOAT);

ALTER TABLE patients ADD COLUMN(weight FLOAT);

SELECT * FROM patients;

INSERT INTO patients(name, age, height, weight) VALUES("Taro", 44, 175.6789, 67.8934);

INSERT INTO patients(name, age, height, weight) VALUES("Taro", 44, 175.67891234, 67.893456767);

CREATE TABLE tmp_float(
	num FLOAT
);

INSERT INTO tmp_float VALUES(12345678); -- 丸められてしまう
INSERT INTO tmp_float VALUES(12345); -- 正確に入る
INSERT INTO tmp_float VALUES(12345.5); -- 6個目までは正確に入る
INSERT INTO tmp_float VALUES(12345.58); -- 7個目になると丸められてしまう 

SELECT * FROM tmp_float;

CREATE TABLE tmp_double(
	num DOUBLE
);

INSERT INTO tmp_double VALUES(1234567); -- 正確な値が入る
INSERT INTO tmp_double VALUES(123456789); -- 正確な値が入る
INSERT INTO tmp_double VALUES(123456789.123456); -- 正確な値が入る
INSERT INTO tmp_double VALUES(123456789.123456789); -- 最後の9が丸められる

SELECT * FROM tmp_double;

SELECT num+2, num FROM tmp_float; -- 計算すると余計におかしな値になってしまうことのある例

-- DECIMAL 計算の時に使うと良い (金融系など)
ALTER TABLE patients ADD COLUMN score DECIMAL(7, 3); -- 整数部: 4, 少数部: 3

SELECT * FROM patients;

INSERT INTO patients(name, age, score) VALUES('Jiro', 54, 32.456);

CREATE TABLE tem_decimal(
	num_float FLOAT,
	num_double DOUBLE,
	num_decimal DECIMAL(20, 10)
);

RENAME TABLE tem_decimal TO tmp_decimal;

INSERT INTO tmp_decimal VALUES(1111111111.1111111111, 1111111111.1111111111, 1111111111.1111111111);

SELECT * FROM tmp_decimal;

SELECT num_decimal, num_decimal*2 + 2 FROM tmp_decimal;
SELECT num_decimal, (num_decimal*2 + 2)/2 FROM tmp_decimal;

-- 論理型
CREATE TABLE managers(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(50),
	is_superuser BOOLEAN
);

INSERT INTO managers(name, is_superuser) VALUES("Taro", true);
INSERT INTO managers(name, is_superuser) VALUES("Jiro", false);

SELECT * FROM managers;

SELECT * FROM managers WHERE is_superuser=true;

SELECT * FROM managers WHERE is_superuser=false;

-- DATE TIME
CREATE TABLE alerms(
	id INT PRIMARY KEY AUTO_INCREMENT,
	alerm_day DATE,
	alerm_time TIME,
	create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT CURRENT_TIMESTAMP, NOW(), CURRENT_DATE, CURRENT_TIME;

INSERT INTO alerms(alerm_day, alerm_time) VALUES("2019-01-01", "19:50:21");
INSERT INTO alerms(alerm_day, alerm_time) VALUES("2021/01/15", "195031");

SELECT * FROM alerms;
UPDATE alerms SET alerm_time = CURRENT_TIME WHERE  id = 1;

SELECT HOUR(alerm_time), alerm_time FROM alerms;
SELECT MINUTE(alerm_time), alerm_time FROM alerms;
SELECT SECOND(alerm_time), alerm_time FROM alerms;
SELECT MONTH(alerm_day), SECOND(alerm_time), alerm_time FROM alerms;
SELECT DAY(alerm_day), SECOND(alerm_time), alerm_time FROM alerms;
SELECT DATE_FORMAT(alerm_day, '%Y'), SECOND(alerm_time), alerm_time FROM alerms;
SELECT DATE_FORMAT(alerm_day, '%M'), SECOND(alerm_time), alerm_time FROM alerms;
SELECT DATE_FORMAT(alerm_day, '%m'), SECOND(alerm_time), alerm_time FROM alerms;
SELECT DATE_FORMAT(alerm_day, '%d'), SECOND(alerm_time), alerm_time FROM alerms;

CREATE TABLE tmp_time(
	num TIME(5)
);

INSERT INTO tmp_time VALUES("21:05:21.54321");

SELECT * FROM tmp_time;

-- DATETIME, TIMESTAMP
CREATE TABLE tmp_datetime_timestamp(
	val_datetime DATETIME,
	val_timestamp TIMESTAMP,
	val_datetime_3 DATETIME(3),
	val_timestamp_3 TIMESTAMP(3)
);

INSERT INTO tmp_datetime_timestamp
VALUES(CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO tmp_datetime_timestamp
VALUES("2019/01/01 09:08:07.5432", "2019/01/01 09:08:07.5432", "2019/01/01 09:08:07.6578", "2019/01/01 09:08:07.6578");

SELECT * FROM tmp_datetime_timestamp;

-- 1969/01/01 00:00:01 古い日付はtimestampには入れられない
INSERT INTO tmp_datetime_timestamp
VALUES("1969/01/01 00:00:01", "1969/01/01 00:00:01", "1969/01/01 00:00:01", "1969/01/01 00:00:01"); -- 入れられない

-- 2039/01/01 00:00:01 新しい日付はtimestampには入れられない
INSERT INTO tmp_datetime_timestamp
VALUES("2039/01/01 00:00:01", "2039/01/01 00:00:01", "2039/01/01 00:00:01", "2039/01/01 00:00:01"); -- 入れられない

INSERT INTO tmp_datetime_timestamp
VALUES("2039/01/01 00:00:01", "2029/01/01 00:00:01", "2039/01/01 00:00:01", "2029/01/01 00:00:01"); -- 2029年は入れられる

INSERT INTO tmp_datetime_timestamp
VALUES("9999/01/01 00:00:01", "2029/01/01 00:00:01", "2039/01/01 00:00:01", "2029/01/01 00:00:01"); -- 可能(DATETIME)

