-- --------------------------- task 1
USE ap;

SELECT *
FROM vendors;

CREATE INDEX vendors_zip_code
	ON vendors (vendor_zip_code);
    
-- --------------------------- task 2

USE ex;

CREATE TABLE committees
(
	committee_id		INT				PRIMARY KEY 	AUTO_INCREMENT,
    committee_name		VARCHAR(50)		NOT NULL
);

CREATE TABLE members
(
	member_id			INT				PRIMARY KEY 	AUTO_INCREMENT,
    first_name			VARCHAR(30)		NOT NULL,
    last_name			VARCHAR(30)		NOT NULL,
    address				VARCHAR(60)		NOT NULL,
    city				VARCHAR(15)		NOT NULL,
    state				VARCHAR(15)		NOT NULL,
    phone				VARCHAR(24)		NOT NULL
);

CREATE TABLE members_committees
(
	member_id 			INT		NOT NULL,
    committee_id		INT		NOT NULL,
    CONSTRAINT members_fk
		FOREIGN KEY (member_id)
        REFERENCES members (member_id),
    CONSTRAINT committees_fk
		FOREIGN KEY (committee_id)
        REFERENCES committees (committee_id)
);

-- --------------------------- task 3

SELECT *
FROM members;

INSERT INTO members VALUES
(DEFAULT,'Neo','Zeo','Address 1','City 1','State 1','123-456-789'),
(DEFAULT,'Mike','Si','Address 2','City 2','State 2','132-465-798');

SELECT *
FROM committees;

INSERT INTO committees VALUES
(DEFAULT,'name_1_c'),
(DEFAULT,'name_2_c');

SELECT *
FROM members_committees;

INSERT INTO members_committees VALUES
(2,2),
(3,1),
(3,2);

SELECT
	c.committee_name,
    m.last_name,
    m.first_name
FROM members m 
	INNER JOIN members_committees mc
		ON m.member_id = mc.member_id
			INNER JOIN committees c
				ON mc.committee_id = c.committee_id
ORDER BY
	c.committee_name,
    m.last_name,
    m.first_name;

-- --------------------------- task 4

ALTER TABLE members
	ADD annual_due		DECIMAL(5,2)	DEFAULT 52.50;
    
ALTER TABLE members
	ADD payment_date	DATETIME;

-- --------------------------- task 5

DESCRIBE committees;

ALTER TABLE committees
	MODIFY committee_name 	VARCHAR(50) 	UNIQUE;









