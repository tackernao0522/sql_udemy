USE day_15_18_db;

CREATE TABLE messages(
	name_code CHAR(8), -- mysqlの場合はオートインクリメントは使えない
	name VARCHAR(25),
	message TEXT -- 65535文字まで可能
);

INSERT INTO messages VALUES("00000001", "Yoshida Takeshi", "aaaaba");
INSERT INTO messages VALUES("00000002", "Yoshida Yusaku", "aaaaba");
