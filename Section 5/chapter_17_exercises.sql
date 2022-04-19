USE ap;

-- ------------------------- task 9

SELECT *
FROM invoices;

DESCRIBE invoices;

INSERT INTO invoices VALUES
(DEFAULT, 37, 12512521, '2018-08-03', 220.00, 0.00, 0.00, 3, '2018-09-03', NULL);

DELETE FROM invoices
WHERE invoice_id = 116;

-- ------------------------- task 10

SET GLOBAL  general_log = ON;

SELECT @@general_log;

-- ------------------------- task 11

SELECT *
FROM invoices;

-- ------------------------- task 12

-- view logs

-- ------------------------- task 13

SET GLOBAL  general_log = OFF;

SELECT @@general_log;



