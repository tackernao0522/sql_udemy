# GROUP BYの書き方
/*
SELECT column1, SUM(column2) FROM table GROUP BY column1;

column1でグループ化して集計する
SLECT column1, SUM(column2), AVG (column2) FROM table_name GROUP BY column1;

column1とcolumn2でグループ化して集計する
SELECT column1, column2, SUM(column3), AVG(column3)
	FROM table_name GROUP BY column1, column2;
	
WHEREで絞り込んでから、グループ化する
SELECT column1, MIN(number) FROM table_name WHERE column1 < "○○"
	GROUP BY column1;
	
集計結果をORDER BYで並び替える
SELECT column1, COUNT(*) FROM table_name GROUP BY column1
	ORDER BY COUNT(*);
*/
SELECT age, COUNT(*) FROM users
	WHERE  birth_place="日本"
	GROUP BY age;

SELECT age, COUNT(*), MAX(birth_day), MIN(birth_day) FROM users
	WHERE  birth_place="日本"
	GROUP BY age;

SELECT age, COUNT(*), MAX(birth_day), MIN(birth_day) FROM users
	WHERE  birth_place="日本"
	GROUP BY age
	ORDER BY age;

SELECT age, COUNT(*), MAX(birth_day), MIN(birth_day) FROM users
	WHERE  birth_place="日本"
	GROUP BY age
	ORDER BY COUNT(*);

SELECT department, SUM(salary) FROM employees
	GROUP BY department;

SELECT department, SUM(salary), AVG(salary) FROM employees
	GROUP BY department;

SELECT department, SUM(salary), AVG(salary), MIN(salary), MAX(salary) FROM employees
	GROUP BY department;

SELECT department, SUM(salary), FLOOR(AVG(salary)), MIN(salary), MAX(salary)
	FROM employees
	GROUP BY department;


SELECT department, SUM(salary), FLOOR(AVG(salary)), MIN(salary), MAX(salary)
	FROM employees
	WHERE age > 40
	GROUP BY department;

# GROUP BYでCASE文を利用する①
/*
GROUP BY内にCASE文を記述する
SELECT CASE
	WHEN name IN ("香川県", "高知県", "愛媛県", "徳島県") THEN "四国"
	ELSE "その他"
	END AS "disttict",
	COUNT(*)
FROM prefectures
	GROPU BY -- GROUP BYの中にCASEを記述
	CASE
		WHEN name IN ("香川県", "高知県", "愛媛県", "徳島県") THEN "四国"
		ELSE "その他"
	END 
*/
SELECT
	CASE
			WHEN birth_place="日本" THEN "日本人"
			ELSE  "その他"
	END,
		COUNT(*) 
	FROM users
	GROUP BY
		CASE
			WHEN birth_place="日本" THEN "日本人"
			ELSE  "その他"
		END;
	
SELECT
	CASE
			WHEN birth_place="日本" THEN "日本人"
			ELSE  "その他"
	END AS "国籍",
		COUNT(*),
		MAX(age)
	FROM users
	GROUP BY
		CASE
			WHEN birth_place="日本" THEN "日本人"
			ELSE  "その他"
		END;
	
SELECT
CASE
	WHEN name IN ("香川県", "高知県", "愛媛県", "徳島県") THEN "四国"
	ELSE "その他"
END AS "地域名",
COUNT(*)
FROM
	prefectures
GROUP BY
CASE
	WHEN name IN ("香川県", "高知県", "愛媛県", "徳島県") THEN "四国"
	ELSE "その他"
END;


# GROUP BYでCASE文を利用する②
/*
SELECT
	age,
	CASE
	WHEN name < 20 THEN "未成年"
	ELSE "成人"
	END AS "分類",
	count(*)
FROM users
GROUP BY
name;
*/

SELECT 
	age,
	CASE 
		WHEN age < 20 THEN "未成年"
		ELSE "成人"
	END AS "分類",
	COUNT(*)
	FROM users
	GROUP BY age;

	

