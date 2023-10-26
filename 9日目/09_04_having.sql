# HAVINGとは
-- グループ化して集計した結果に対して、絞り込みをする場合に用いるSQL

# HAVINの書き方
/*
SUM(column2)が10000よりも大きい場合
SELECT column1, SUM(column2), AVG(column2) FROM table_name GROUP BY column1
	HAVING SUM(column2) > 10000;
*/
SELECT department, AVG(salary)
	FROM employees 
	GROUP BY department
	HAVING AVG(salary) > 3980000;
	
/*
column1とcolumn2でグループ化して、AVG(column1)の値で絞り込み集計する
SELECT column1, column2, SUM(column3), AVG(column3)
	FROM table_name
	GROUP BY column1, column2
	HAVING AVG(column1) < 10000;
*/
SELECT birth_place, age, COUNT(*) 
	FROM users
	GROUP BY birth_place, age
	HAVING COUNT(*) > 1;

/*
WHEREで絞り込んでから、グループ化して、HAVINGで絞り込む
SELECT column1, MIN(number) FROM table_name
	WHERE column1<"○○"
	GROUP BY column1 HAVING MIN(number) < 10000;
*/

/*
集計結果をORDER BYで並び替える
SELECT column1, COUNT(*)
	FROM table_name
	GROUP BY column1
	HAVING COUNT(*) < 100
	ORDER BY COUNT(*);
*/

SELECT birth_place, age, COUNT(*) 
	FROM users
	GROUP BY birth_place, age
	HAVING COUNT(*) > 1
	ORDER BY age;

SELECT birth_place, age, COUNT(*) 
	FROM users
	GROUP BY birth_place, age
	HAVING COUNT(*) > 1
	ORDER BY COUNT(*);

# GROUP BYを使わない場合のHAVINGの書き方
/*
HAVINGはGROUP BYとセットで利用する印象があるが(古いSQLではGROUP BYとセット出ないと利用できないが)、
実際はHAVINGだけで利用することもできる。

HAVINGでは、集計結果の比較に用いる

# HAVINGで集計結果を比較
#(DISTINCT(重複を削除するSQL)の場合とCOUNTを比較して重複チェック)
SELECT
    "重複あり"
FROM
	tbl
HAVING
	COUNT(id) <> COUNT(DISTINCT id);
*/
SELECT 
	"重複なし"
FROM
	users
HAVING
	COUNT(DISTINCT name) = COUNT(name);

SELECT 
	"重複なし" AS "check"
FROM
	users
HAVING
	COUNT(DISTINCT age) = COUNT(age);
