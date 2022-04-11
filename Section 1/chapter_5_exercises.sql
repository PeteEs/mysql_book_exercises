USE ap;

-- ----------------------- task 1

SELECT *
FROM terms;

INSERT INTO terms VALUES
(6,'Net due 120 days',120);

-- ----------------------- task 2

SELECT *
FROM terms;

UPDATE terms
SET terms_description = 'Net due 125 days',
	terms_due_days = 125
WHERE
	terms_id = 6;
    
-- ----------------------- task 3

DELETE FROM terms
WHERE
	terms_id = 6;

SELECT *
FROM terms;

-- ----------------------- task 4

SELECT *
FROM invoices;

INSERT INTO invoices VALUES
(DEFAULT,32,'AX-014-027','2018-08-01',434.58,DEFAULT,DEFAULT,2,'2018-08-31',NULL);

SELECT *
FROM invoices
WHERE vendor_id = 32;

-- ----------------------- task 5

SELECT *
FROM invoice_line_items;

-- invoice_id = 115

DESCRIBE invoice_line_items;

INSERT INTO invoice_line_items VALUES
(115,1,160,180.23,'Hard drive'),
(115,2,527,254.35,'Exchange Server update');

-- ----------------------- task 6

UPDATE invoices
SET
	credit_total = 0.1*invoice_total,
    payment_total = 0.1*invoice_total + invoice_total
WHERE
	invoice_id = 115;

SELECT *
FROM invoices
WHERE invoice_id = 115;

-- ----------------------- task 7

UPDATE vendors
SET
	default_account_number = 403
WHERE
	vendor_id = 44;
    
SELECT *
FROM vendors
WHERE vendor_id = 44;

-- ----------------------- task 8
    
SELECT *
FROM vendors
WHERE default_terms_id = 2;

SELECT vendor_id
FROM vendors
WHERE default_terms_id = 2;

SELECT *
FROM invoices
WHERE vendor_id IN
	(SELECT vendor_id
	FROM vendors
	WHERE default_terms_id = 2);

UPDATE invoices
SET 
	terms_id = 2
WHERE vendor_id IN
	(SELECT vendor_id
	FROM vendors
	WHERE default_terms_id = 2);

-- ----------------------- task 9

DELETE from invoice_line_items
WHERE
	invoice_id = 115 AND invoice_sequence IN (1,2);

DELETE FROM invoices
WHERE
	invoice_id = 115;
