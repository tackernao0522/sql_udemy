SHOW DATABASES;

CREATE DATABASE day_15_18_db;

USE day_15_18_db;

SHOW TABLES;

CREATE TABLE users(
	id INT PRIMARY KEY,
	first_name VARCHAR(255),
	last_name VARCHAR(255) DEFAULT '' NOT NULL
);


INSERT INTO users(id) VALUES(1);

SELECT * FROM users;

CREATE TABLE users_2(
	id INT PRIMARY KEY,
	first_name VARCHAR(255),
	last_name VARCHAR(255) NOT NULL,
	age INT DEFAULT 0
);

# INSERT INTO users_2(id, first_name) VALUES(1, "Taro"); エラーになる

INSERT INTO users_2(id, first_name, last_name) VALUES (1, "Taro", "Yamada");

SELECT * FROM users_2;

INSERT INTO users_2 VALUES(2, "Jiro", "Suzuki", NULL); # NOT NULLしていないカラムはNULL値が入れられる

SELECT * FROM users_2;

-- UNIQUE制約
CREATE TABLE login_users(
	id INT PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO login_users VALUES(1, "Shingo", "abc@mail.com");
# INSERT INTO login_users VALUES(2, "Shingo", "abc@mail.com"); emailはUNIQUE制約があるので、エラーになる

CREATE TABLE tmp_names(
	name VARCHAR(255) UNIQUE
);

INSERT INTO tmp_names VALUES("Taro"); # 2回目はUNIQUE制約によりエラーになる
INSERT INTO tmp_names VALUES(NULL); # 何回INSERTしてもNULLはUNIQUE制約に引っかからない

SELECT * FROM tmp_names;


