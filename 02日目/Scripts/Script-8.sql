USE day_4_9_db;

SELECT DATABASE ();

SHOW TABLES;

-- IF
/*
 * 条件式をチェックして、真の場合と偽の場合とで表示内容を変える
 * IF(条件式, 真の場合の値, 偽の場合の値)
*/

# IFで条件式を判定
# SELECT IF(100 < 200, "真", "偽"); # 真と表示
SELECT IF(10 < 20, "A", "B"); # A
SELECT IF(10 > 20, "A", "B"); # B

SELECT * FROM users;

SELECT *, IF(birth_place="日本", "日本人", "その他") AS "国籍" FROM users;

SELECT name, age, IF(age < 20, "未成年", "成人") FROM users;

# IFで複数の条件式を判定
# SELECT IF(100 < 200 AND 300 < 200, "真", "偽"); # 偽と表示
SELECT * FROM students;

SELECT *, IF(class_no AND height > 170, "6組の170cm以上の人", "その他") FROM students;

# IFでカラムの取得結果を変換する
# SELECT IF (name LIKE "T%", "Tで始まる名前です", "Tで始まらない名前です") FROM users;
SELECT * FROM users;

SELECT name, IF(name LIKE "%田%", "名前に田を含む", "その他") AS name_check FROM users;

