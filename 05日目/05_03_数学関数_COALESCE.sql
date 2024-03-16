-- ROUND, FLOOR, CEILING

SELECT ROUND(3.14); -- 3 四捨五入
SELECT ROUND(3.14, 1); -- 3.2
SELECT ROUND(3.14, -1); -- 0
SELECT ROUND(13.14, -1); -- 10

SELECT FLOOR(3.14); -- 3 切り捨て
SELECT FLOOR(3.84); -- 3

SELECT CEILING (3.14); -- 4 切り上げ

SELECT RAND(); -- 0〜1の小数のランダム値を取得する (0, 1は含まない) 例: 0.4895061492
SELECT RAND() * 10; -- 0〜10のランダム値を取得する 例: 8.8306905877
SELECT FLOOR(RAND() * 10); -- 整数0〜10の値がランダムに取得される 小数点以下が切り捨てられる

-- POWER(べき乗)
SELECT POWER(3,4); -- 81.0

SELECT weight / POWER(height/100,2) AS BMI FROM students;

-- COALESCE

/*
 * 最初に登場するNULLでない値を返す関数
 * COALESCE(列1, 列2, ・・・)
 * SELECT COALESCE('A', 'B', 'C'); # Aと表示される
 * SELECT COALESCE(NULL, 'B', 'C'); # Bと表示される
 * SELECT COALESCE(NULL, 'B', NULL); # Bと表示される
 * SELECT COALESCE(NULL, NULL, 'C'); # Cと表示される
 * SELECT COALESCE(column1, column2, column3) FROM users;
 * (usersテーブルから取得して、column1, column2, column3のうち、NULLでない最初の文字を表示)
*/
SELECT * FROM tests_score;

SELECT COALESCE(NULL, NULL, NULL, "A", NULL, "B"); # A

SELECT COALESCE(test_score_1, test_score_2, test_score_3) AS score FROM tests_score;

SELECT COALESCE(
  test_score_1, test_score_2, test_score_3
    ), test_score_1, test_score_2, test_score_3  AS score
      FROM tests_score;
