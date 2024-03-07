-- 4日目のDocumentのnullの評価式を確認する
-- IN + NULL
SELECT * FROM customers WHERE name IS NULL; # NULLの人を取得する
SELECT * FROM customers WHERE name IN ("河野 文典", "稲田 季雄") OR name IS NULL; # 評価は ture or nullで trueになる(（）の中もNULLも取得できることになる)

-- NOT IN
SELECT * FROM customers WHERE name NOT IN ("河野 文典", "稲田 季雄", NULL);

-- NOT IN -> name != "河野 文典" name != "稲田 季雄" name != NULL(上記はこのようになるので全てNULLになりレコードは取り出せなくなる)

-- よってレコードを取得するためには下記のようになる

SELECT * FROM customers WHERE name NOT IN ("河野 文典", "稲田 季雄") AND name IS NOT NULL;

-- ALL
SELECT * FROM users WHERE birth_day <= ALL(SELECT birth_day FROM customers WHERE id < 10); # (NULLが入っているので何も取り出せない)

-- customersテーブルからid<10の人の誕生日よりも古い誕生日の人をusersから取り出すSQL
SELECT * FROM users WHERE birth_day 
	<= ALL(SELECT birth_day 
		FROM customers
		WHERE id < 10 
		AND birth_day IS NOT NULL
		); # レコードを取り出せる
		
-- ALL, INの場合はNULLには気をつけましょう！

