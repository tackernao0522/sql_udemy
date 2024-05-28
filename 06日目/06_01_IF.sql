SELECT DATABASE();

SHOW TABLES;

-- IF
/*
 * 条件式をチェックして、真の場合と偽の場合とで表示内容を変える
 * IF(条件式、真の場合の値、偽の場合の値)
*/

--  IFで条件式を判定
-- SELECT IF(100 < 200, "真", "偽"); 真と表示
SELECT IF(10 < 20, "A", "B"); -- A
SELECT IF(10 > 20, "A", "B") -- B

SELECT * FROM users;

-- birth_placeが日本の場合は国籍が日本人になり、それ以外のbirth_placeは国籍がその他になる
SELECT *, IF(birth_place="日本", "日本人", "その他") AS "国籍" FROM users;

-- ageが20歳未満の場合のnameの表示とageの表示及びその場合は未成年と表示、ageが20歳以上の場合のnameとageの表示及びその場合は成人と表示
SELECT name, age, IF(age < 20, "未成年", "成人") FROM users;

-- IFで複数の条件式を判定する
-- SELECT IF(100 < 200 AND 300 < 200, "真", "偽"); -- 偽と表示
SELECT * FROM students;

-- class_noが6の人で、heightが170以上の人は "6組の170cm以上の人"と表示、それ以外は"その他"と表示
SELECT *, IF(class_no = 6 AND height >= 170, "6組の170cm以上の人", "その他") from students;

-- IFでカラムの取得結果を変換する
-- SELECT IF (name LIKE "T%", "Tで始まる名前です", "Tで始まらない名前です") FROM users;
SELECT * FROM users;

-- usersテーブルのnameに"田"が含む人は name_checkに"名前に田を含む"と表示、それ以外は "その他"と表示
SELECT name, IF(name LIKE "%田%", "名前に田を含む", "その他") AS name_check FROM users;
