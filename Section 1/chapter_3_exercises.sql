USE ap;

-- ----------------------------- task 8

SELECT 
	vendor_name,
    vendor_contact_last_name,
    vendor_contact_first_name
FROM vendors
ORDER BY 
	vendor_contact_last_name,
    vendor_contact_first_name;
    
-- ----------------------------- task 9

SELECT 
	CONCAT(vendor_contact_last_name,', ',vendor_contact_first_name) AS full_name
FROM vendors
WHERE
	vendor_contact_last_name REGEXP '^[ABCE]'
ORDER BY
	vendor_contact_last_name,
    vendor_contact_first_name;
    
-- ----------------------------- task 10

SELECT
	invoice_due_date AS Due_Date,
    invoice_total AS Invoice_Total,
    0.1*invoice_total AS '10%',
    0.1*invoice_total + invoice_total AS 'Plus 10%'
FROM invoices
WHERE
	invoice_total BETWEEN 500 AND 1000;
    
-- ----------------------------- task 11
    
SELECT *
FROM invoices;
    
SELECT 
	invoice_number,
    invoice_total,
    payment_total + credit_total AS payment_credit_total,
    invoice_total - payment_total - credit_total AS balance_due
FROM invoices
WHERE
	invoice_total - payment_total - credit_total > 50
ORDER BY
	balance_due DESC
LIMIT 5;
    
-- ----------------------------- task 12

SELECT
	invoice_number,
    invoice_date,
    invoice_total - payment_total - credit_total AS balance_due,
    payment_date
FROM invoices
WHERE
	payment_date IS NULL;

-- ----------------------------- task 13

SELECT
	DATE_FORMAT(CURRENT_DATE, '%m-%d-%Y') AS 'mm-dd-yyyy';

-- ----------------------------- task 14

SELECT
	50000 AS starting_principal,
    0.065*50000 AS interest,
    50000 + 0.065*50000 AS principal_plus_interest;







    
    
    
    

    