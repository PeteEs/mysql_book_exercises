USE ap;

-- ----------------------- task 1

SELECT *
FROM invoices;

SELECT 
	invoice_total,
    FORMAT(invoice_total,1) AS format_1,
    CONVERT(invoice_total,SIGNED) AS integer_total_convert,
    CAST(invoice_total AS SIGNED) AS integer_total_cast
FROM invoices;

-- ----------------------- task 2

SELECT *
FROM invoices;

SELECT 
	invoice_date,
    CAST(invoice_date AS DATETIME) AS datetime_date,
    CAST(invoice_date AS CHAR(7)) AS yr_mo
FROM invoices;
