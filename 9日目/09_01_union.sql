SHOW DATABASES;
USE day_4_9_db;

-- UNION : 重複は削除される
SELECT * FROM new_students
UNION
SELECT * FROM students;
 /*
339|松本 正輝 |   159|    61|       3|
340|荒川 美喜夫|   179|    68|       4|
341|堀川 迪子 |   177|    77|       5|
  4|黒沢 敬正 |   163|    74|       1|
  5|中谷 純典 |   159|    62|       2|
  7|吉川 一樹 |   169|    68|       4|
  8|齋藤 保行 |   181|    81|       3|
 11|田原 秀俊 |   179|    72|       5|
 12|八木 利人 |   156|    76|       6|
 13|宮田 紀子 |   180|    61|       2|
*/

SELECT * FROM new_students
UNION
SELECT * FROM students
ORDER BY id;

-- UNION ALL: 重複削除しない
SELECT * FROM new_students
UNION ALL
SELECT * FROM students;

SELECT * FROM new_students
UNION ALL
SELECT * FROM students
ORDER BY id;

/*
id |name  |height|weight|class_no|
---+------+------+------+--------+
  1|今野 耕介 |   170|    66|       6|
  1|今野 耕介 |   170|    66|       6|
  2|根本 仁美 |   154|    71|       1|
  2|根本 仁美 |   154|    71|       1|
  3|伊東 元久 |   150|    78|       2|
  3|伊東 元久 |   150|    78|       2|
  4|黒沢 敬正 |   163|    74|       1|
  5|中谷 純典 |   159|    62|       2|
  6|荒井 鋭充 |   153|    81|       6|
*/

SELECT * FROM students WHERE id < 10
UNION ALL
SELECT * FROM  students WHERE id > 250;

SELECT * FROM students WHERE id < 10
UNION ALL
SELECT * FROM  new_students WHERE id > 250;

-- 下記はidとageは型が同じなので可能
SELECT id, name FROM students WHERE id<10
UNION
SELECT age, name FROM users WHERE id<10;

-- ORDER BYする時は一つ目のSQLのカラム名に合わせる
SELECT id, name FROM students WHERE id<10
UNION
SELECT age, name FROM users WHERE id<10
ORDER BY id;

-- カラムの数は必ず合わせないとエラーになる
/*
SELECT id, name, height FROM students
UNION ALL
SELECT age, name FROM users;
*/