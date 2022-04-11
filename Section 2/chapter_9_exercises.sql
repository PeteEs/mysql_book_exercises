USE ap;

-- ----------------------- task 1

SELECT *
FROM invoices;

SELECT
	ROUND(invoice_total,1) AS round_1,
    ROUND(invoice_total,0) AS round_0,
    TRUNCATE(invoice_total,0) AS truncate_0
FROM invoices;

-- ----------------------- task 2

USE ex;

SELECT *
FROM date_sample;

SELECT
	start_date,
    DATE_FORMAT(start_date, '%b %m/%d/%y') AS date_format_1,
    DATE_FORMAT(start_date, '%c-%e-%y') AS date_format_2,
    DATE_FORMAT(start_date, '%l:%i %p') AS date_format_3
FROM date_sample;

-- ----------------------- task 3

USE ap;

SELECT *
FROM vendors;

SELECT
	vendor_name,
    UPPER(vendor_name) AS upper_name,
    vendor_phone,
    RIGHT(vendor_phone,4) AS last_4,
    REPLACE(REPLACE(REPLACE(vendor_phone,'(',''),') ','.'),'-','.') AS phone_dots,
    IF(LOCATE(' ',vendor_name) = 0, -- condition
		'',
		IF(LOCATE(' ', vendor_name, LOCATE(' ', vendor_name) + 1) = 0, -- condition
			SUBSTRING(vendor_name, LOCATE(' ', vendor_name) + 1),
			SUBSTRING(vendor_name, LOCATE(' ', vendor_name) + 1, LOCATE(' ', vendor_name, LOCATE(' ', vendor_name) + 1) - LOCATE(' ', vendor_name)))) AS 2nd_word
FROM vendors;

-- ----------------------- task 4

SELECT
	invoice_number,
    invoice_date,
    invoice_date,
	DATE_ADD(invoice_date, INTERVAL 30 DAY) AS 30_days_added,
    payment_date,
    DATEDIFF(payment_date, invoice_date) AS date_diff,
    DATE_FORMAT(invoice_date, '%c') AS month_of_invoice,
    DATE_FORMAT(invoice_date, '%Y') AS year_of_invoice
FROM invoices;

-- ----------------------- task 5

USE ex;

SELECT *
FROM string_sample;

SELECT 
	emp_name,
	REGEXP_SUBSTR(emp_name, '^[A-Z]*') AS first_name,
    REGEXP_SUBSTR(emp_name, ' [A-Z]* [A-Z,\',-]*$| [A-Z,\',-]*$') AS last_name
FROM string_sample;

-- ----------------------- task 6

USE ap;

SELECT *
FROM invoices;

SELECT
	invoice_number,
    invoice_total - payment_total - credit_total AS balance_due,
    RANK() OVER (ORDER BY invoice_total - payment_total - credit_total DESC) AS ranks
FROM invoices
WHERE 
	invoice_total - payment_total - credit_total > 0;

