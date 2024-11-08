-- CASE
/*
 * 複数の条件式をチェックして、条件に応じて表示する値を変える(IFの上位互換)
*/

/*
CASE式1
CASE 評価する例
	WHEN 値1 THEN 値1のときに返す値
    (WHEN 値2 THEN 値2のときに返す値)
    (ELSE デフォルト値)
END
*/

/*
SELECT
  CASE contry
	WHEN "Japan" THEN "日本人" # countryがJapanの時の表示内容
    ELSE "外国人" # countryがJapan以外の時の表示内容
  END AS "国籍"
FROM users;
*/

SELECT * FROM users;

SELECT
	*,
	CASE birth_place
	WHEN "日本" THEN "日本人"
	ELSE "外国人"
	END AS "国籍"
FROM
	users;

SELECT
	*,
	CASE birth_place
	WHEN "日本" THEN "日本人"
	WHEN "Iraq" THEN "イラク人"
	ELSE "外国人"
	END AS "国籍"
FROM
	users;

SELECT
	*,
	CASE birth_place
	WHEN "日本" THEN "日本人"
	WHEN "Iraq" THEN "イラク人"
	ELSE "外国人"
	END AS "国籍"
FROM
	users
WHERE id>30;

SELECT * FROM prefectures;

#  CAS􏰁E式には、他にも複雑な評価をする記述方法がある

/*
CA􏰁SE式2(こちらのほうが一般的) 

CASE
  WHEN 評価式1 THEN 評価式1が真の時に返す値
  (WHEN 評価式2 THEN 評価式2が真の時に返す値)
  (ELSE デフォルト値)
END
*/

/*
# 香川、愛媛、徳島、高知のときは四国と表示する

SELECT 
	CASE 
		WHEN name IN("香川", "愛媛", "徳島", "高知") THEN "四国"
		ELSE "その他"
	END AS "地域名"
FROM prefectures;
*/

SELECT
	name,
	CASE 
		WHEN name IN("香川県", "愛媛県", "徳島県", "高知県") THEN "四国"	
		WHEN name IN("兵庫県", "大阪府", "京都府", "滋賀県", "奈良県", "三重県", "和歌山県") THEN "近畿"
		ELSE "その他"
	END AS "地域名"
FROM
	prefectures;

-- 計算(うるう年、4の余り==0, 100の余り!=0)
SELECT
	*
FROM users;

/*
 *　うるう歳について
 *  厳密には、4で割り切れて、100では割り切れない。
 *  もしくは、400で割り切れる年がうるう年です。
 */
SELECT 
	name,
	birth_day,
	CASE
		WHEN DATE_FORMAT(birth_day, "%Y") % 4 = 0 
			AND DATE_FORMAT(birth_day, "%Y") % 100 <> 0  THEN "うるう年"
		ELSE "うるう年でない"
	END AS "うるう年か"	
FROM users;

SELECT * FROM tests_score;

SELECT
	*,
	CASE 
		WHEN student_id % 3 = 0 THEN test_score_1
		WHEN student_id % 3 = 1 THEN test_score_2
		WHEN student_id % 3 = 2 THEN test_score_3
	END AS score
FROM tests_score;
	
	
