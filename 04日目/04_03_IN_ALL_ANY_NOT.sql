-- IN, NOT IN
/*
 * ()内に列挙した複数の値のいずれかに合致したものを取り出す
 * 式(カラム名) IN (値1, 値2, 値3, ・・・)
*/

-- IN
SELECT * FROM users WHERE age IN(12, 24, 36);

/*
 * customersテーブルからcountry列がJapan, US, UKのいずれかに当てはまるものを取り出す
 * 
 * SELECT * FROM customers
 * WHERE country IN ('JAPAN', 'US', 'UK');
*/

SELECT * FROM users WHERE birth_place IN ("France", "Germany", "Italy");

SELECT * FROM users WHERE birth_place NOT IN ("France", "Germany", "Italy"); # 以外

/*
 * suppliersテーブルからcountry列を取り出す。countryに該当するものをcustomersテーブルから取り出す
 * 
 * SELECT * FROM customers
 * WHERE country IN (SELECT country FROM suppliers);
*/
-- SELECT + IN
# SELECT customer_id FROM receipts WHERE id < 10;
SELECT * FROM customers WHERE id IN (SELECT customer_id FROM receipts); # customersのidがcustomer_idに入っている人だけ取り出す
SELECT * FROM customers WHERE id IN (SELECT customer_id FROM receipts WHERE id < 10); # receiptsのidが10以下でcustomersのidがcustomer_idに入っている人だけ取り出す
SELECT * FROM customers WHERE id NOT IN (SELECT customer_id FROM receipts WHERE id < 10); # receiputsのidが10以下でcustomersのidがcustomer_idに入っている人以外を取り出す 上記と逆

-- ANY
/*
 * 取得した値のリストと比較して、いずれかが真のものを取り出す
 * 式(カラム) 比較演算子 ANY (SELECT ・・・) 
*/

# goodsテーブルからidが5よりも大きなレコードのpriceを取り出す。
# 取り出したpriceのいずれかの値より小さいレコードをproductsテーブルから取り出す。

/*
 * SELECT * FROM products
 * WHERE price < ANY (SELECT price FROM goods WHERE id > 5);
*/
SELECT age FROM employees WHERE salary > 5000000;
SELECT * FROM users WHERE age > ANY(SELECT age FROM employees WHERE salary > 5000000); # SELECT age FROM employees WHERE salary > 5000000の結果が一番小さいageよりも大きいusersのage
SELECT * FROM users WHERE age = ANY(SELECT age FROM employees WHERE salary > 5000000); # SELECT age FROM employees WHERE salary > 5000000の結果のいずれか等しいものを取得

-- ALL
/*
 * 取得した値のリストと比較して、全てが真のものを取り出す
 * 式(カラム名) 比較演算子 ALL (SELECT ・・・) 
*/

/* doodsテーブルからidが5よりも大きなレコードのpriceを取り出す。
 * 取り出したpriceのどの値よりも小さいレコードをproductsテーブルから取り出す。
 * 
 * SELECT * FROM products
 * WHERE price < ALL (SELECT price FROM goods WHERE id > 5);
*/

SELECT * FROM users WHERE age > ALL(SELECT age FROM employees WHERE salary > 5000000); # 取り出したageの全てよりも大きいもの(一番大きなageの値よりも大きいもの
SELECT MAX(age) FROM employees WHERE salary > 5000000; # 45なので上記は45より大きいusersのage

--  AND
/*
 * 二つの条件の両方が真の場合だけ、真となる
 * 条件式1 AND 条件式2 
*/

# ageが20より大きく nameがAで始まるレコードを、customersテーブルから取り出す。
/*
 * SELECT * FROM customers
 * WHERE age>20 AND name LIKE "A%";
*/

SELECT * FROM employees;
SELECT * FROM employees WHERE department = " 営業部 " AND name LIKE "%田%";
SELECT * FROM employees WHERE department = " 営業部 " AND name LIKE "%田%" AND age < 35;

-- OR
/*
 * 2つの条件のどちらかが真の場合だけ、真となる
 * 条件式1 OR 条件式2 
*/

# ageが20より大きい、またはnameがAで始まるレコードを、customersテーブルから取り出す
/*
 * SELECT * FROM customers
 * WHERE age > 20 OR name LIKE "A%"; 
*/

SELECT * FROM employees WHERE department = " 営業部 " OR department = " 開発部 ";
SELECT * FROM employees WHERE department IN (" 営業部 ", " 開発部 "); # 上記と同じ結果

-- AND + OR
/*
 * ANDとORと()を用いて、複数の条件をつなぐことができる
 * 条件式1 AND (条件式2 OR 条件式3)
*/

# idが1または5でかつ、salaryが5000よりも大きいレコードを、employeesテーブルから取り出す
/*
 * SELECT * FROM employees
 * WHERE salarly > 5000 AND (id = 1 OR id = 5);
*/

SELECT * FROM employees WHERE department = " 営業部 " 
	AND (name LIKE "%田%" OR name LIKE "%西%")
	AND age = 35;

-- NOT
/*
 * 条件式の直前につけると条件式の否定になる
 * NOT 条件式
*/

# ageが20より大きくない(20以下)のレコードを、studentsテーブルから取り出す
/*
 * SELECT * FROM students
 * WHERE NOT age > 20;
*/

SELECT * FROM employees WHERE NOT department = " 営業部 ";

