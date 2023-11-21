SHOW DATABASES;

USE day_15_18_db;

SHOW TABLES;

DROP TABLE students;

CREATE TABLE schools(
	id INT PRIMARY KEY,
	name VARCHAR(255)
);

CREATE TABLE students(
	id INT PRIMARY KEY,
	name VARCHAR(255),
	age INT,
	school_id INT,
	FOREIGN KEY(school_id) REFERENCES schools(id)
);

INSERT INTO schools VALUES(1, "北高校");

INSERT INTO students VALUES(1, "Taro", 18, 1); -- schoolのidが存在するものじゃないと不可なのでこの前に schoolsテーブルにデータを入れなくてはならない

-- school_idに指し示す先がないと、参照整合性エラー
-- UPDATE schools SET id=2; schoolsのid1がなくなってしまうのでエラーになる

-- 参照整合性エラー
-- DELETE FROM schools; schoolsのidがなくなるのでエラーで削除できない

-- 参照整合性エラー
-- UPDATE students SET school_id = 3;

DESCRIBE employees;

-- 複数のカラムに外部キー
CREATE TABLE salaries(
	id INT PRIMARY KEY,
	company_id INT,
	employee_code CHAR(8),
	payment INT,
	paid_date DATE,
	FOREIGN KEY (company_id, employee_code) REFERENCES employees(company_id, employee_code)
);

SELECT * FROM employees;

-- INSERT INTO salaries VALUES(1, 1, "00000003", 1000, "2020-01-01"); employee_codeの整合性がとれずエラーになる
INSERT INTO salaries VALUES(1, 1, "00000001", 1000, "2020-01-01");
