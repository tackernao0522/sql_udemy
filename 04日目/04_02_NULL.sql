SELECT DATABASE();

DESCRIBE customers;

-- IS NULLでないと取り出せない
SELECT * FROM customers WHERE name IS NULL;

SELECT NULL IS NULL;

-- IS NOT NULL
SELECT * FROM  customers WHERE name IS NOT NULL;

SELECT * FROM prefectures;

SELECT * FROM prefectures WHERE name IS NULL;

SELECT * FROM prefectures WHERE name = "";

-- BETWEEN
SELECT * FROM users WHERE age BETWEEN 5 AND 10; # 5以上10以下

-- NOT BETWEEN
SELECT * FROM users WHERE age NOT BETWEEN 5 AND 10; # 5より小さいか10より大きいか

-- LIKE
SELECT * FROM users WHERE name LIKE "村%"; # 前方一致

SELECT * FROM users WHERE name LIKE "%郎"; # 後方一致

SELECT * FROM users WHERE name LIKE "%a%"; # 中間一致

SELECT * FROM users WHERE name LIKE "%ed%"; # edの中間一致

SELECT * FROM prefectures WHERE name LIKE "福_県"; # _ は任意の1文字

SELECT * FROM prefectures WHERE name LIKE "福_県" ORDER BY name;
