-- LENGTH, CHAR_LENGTH
SELECT LENGTH("ABC");
SELECT LENGTH("あいう"); -- 9 バイト数

SELECT name, LENGTH(name) FROM users;

SELECT CHAR_LENGTH("ABC"); -- 文字数
SELECT CHAR_LENGTH("あいう") AS length; -- 3 文字数

SELECT name, CHAR_LENGTH(name) FROM users; -- 文字数

-- TRIM, LTRIM, RTRIM 空白削除
SELECT LTRIM(" ABC ") AS a;
SELECT RTRIM(" ABC ") AS a;
SELECT TRIM(" ABC ") AS a; -- 両側の空白が削除される

/**
 * SELECT name, CHAR_LENGTH(name) AS name_length は、"name" 列のデータを選択し、その名前の文字数を CHAR_LENGTH 関数を用いて計算し、別名 "name_length" として取得します。

 * WHERE CHAR_LENGTH(name) <> CHAR_LENGTH(TRIM(name)) は、名前の文字数がトリム（前後の空白を除去）後に変わる従業員を条件でフィルタリングします。これにより、名前に前後の空白が存在する従業員が選択されます。

 * したがって、このクエリは、名前に前後の空白が存在する従業員の名前と文字数を取得します。
*/

SELECT name, CHAR_LENGTH(name) AS name_length
	FROM employees 
		WHERE CHAR_LENGTH(name) <> CHAR_LENGTH(TRIM(name));
	
-- UPDATEして空白を削除したものにする
UPDATE employees 
  SET name = TRIM(name)
  WHERE CHAR_LENGTH(name) <> CHAR_LENGTH(TRIM(name));

