USE day_10_14_db;

-- NULLは紐付けされない
SELECT * FROM customers AS c1
	WHERE EXISTS 
		(SELECT * FROM customers_2 AS c2
			WHERE c1.first_name = c2.first_name
				AND c1.last_name = c2.last_name
					AND c1.phone_number = c2.phone_number
				);

SELECT * FROM customers;

-- NULLも取得できる
SELECT * FROM customers AS c1
	WHERE EXISTS 
		(SELECT * FROM customers_2 AS c2
			WHERE c1.first_name = c2.first_name
				AND c1.last_name = c2.last_name
		);
	
-- EXISTS(NULLの存在する場合)
SELECT * FROM customers AS c1
	WHERE EXISTS 
		(SELECT * FROM customers_2 AS c2
			WHERE c1.first_name = c2.first_name
				AND c1.last_name = c2.last_name
					AND (c1.phone_number = c2.phone_number
						OR (c1.phone_number IS NULL AND c2.phone_number IS NULL)
				));
				
-- NOT EXISTS
SELECT * FROM customers AS c1
	WHERE NOT EXISTS
		(SELECT * FROM customers_2 AS c2
			WHERE c1.first_name = c2.first_name
				AND c1.last_name = c2.last_name
					AND c1.phone_number = c2.phone_number);
					
-- NOT IN の場合
-- first_name != custormers_2.first_name OR last_name != customers_2.last_name OR phone_number != customers_2.phone_number

-- NOT EXISTSの場合
-- EXISTSで紐づかなかったレコード

				

SELECT * FROM customers AS c1
	WHERE (first_name, last_name, phone_number) NOT IN
		(SELECT first_name, last_name, phone_number FROM customers_2);

/*
NOT INの場合、phone_number != customers_2.phone_numberが
NULL != NULL の評価式の場合、偽ではなく不明となるため、取得されない

NOT EXISTS の場合、(c1.first_name = c2.first_name AND c1.last_name = c2.lastname AND c1.phone_number = c2.phone_number)以外のレコードを取り出すので、
phone_numberが両方NULLだった場合も”以外に含まれ"取得される
*/
	
-- EXISTSをINで書く

SELECT * FROM customers AS c1
	WHERE (first_name, last_name, phone_number) IN
		(SELECT first_name, last_name, phone_number FROM customers_2);
