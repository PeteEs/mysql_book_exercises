-- ------------------------- task 1

-- use MySQL Workbench to connect as the root user

-- ------------------------- task 2

CREATE USER IF NOT EXISTS ray@localhost 
IDENTIFIED BY 'temp' PASSWORD EXPIRE INTERVAL 90 DAY;

GRANT SELECT, INSERT, UPDATE
ON ap.vendors
TO ray@localhost
WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE
ON ap.invoices
TO ray@localhost
WITH GRANT OPTION;

GRANT SELECT, INSERT
ON ap.invoice_line_items
TO ray@localhost
WITH GRANT OPTION;

-- ------------------------- task 8

GRANT UPDATE
ON ap.invoice_line_items
TO ray@localhost
WITH GRANT OPTION;

-- ------------------------- task 9

CREATE USER IF NOT EXISTS dorothy
IDENTIFIED BY 'sesame';

CREATE ROLE ap_user;

GRANT SELECT, INSERT, UPDATE
ON ap.*
TO ap_user;

GRANT ap_user
TO dorothy;

-- ------------------------- task 10

SHOW GRANTS FOR dorothy;

-- ------------------------- task 12

SELECT CURRENT_ROLE();





