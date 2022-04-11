USE ap;

-- ----------------------- task 1

SELECT *
FROM invoices;

SELECT
	vendor_id,
    SUM(invoice_total) AS invoice_total_per_vendor
FROM invoices
GROUP BY
	vendor_id;

-- ----------------------- task 2

SELECT *
FROM invoices;

SELECT
	vendor_id,
    SUM(payment_total) AS payment_total_per_vendor
FROM invoices
GROUP BY
	vendor_id
ORDER BY
	SUM(payment_total) DESC;

-- ----------------------- task 3

SELECT
	v.vendor_name,
    COUNT(i.invoice_id) AS invoices_count_per_vendor,
    SUM(i.invoice_total) AS invoice_total_per_vendor
FROM vendors v
	INNER JOIN invoices i
		ON v.vendor_id = i.vendor_id
GROUP BY
	v.vendor_name
ORDER BY
	COUNT(i.invoice_id) DESC;

-- ----------------------- task 4

SELECT *
FROM general_ledger_accounts;

SELECT *
FROM invoice_line_items;

SELECT 
	-- gla.account_number,
	gla.account_description,
    COUNT(ili.invoice_id) AS no_of_invoices,
    SUM(ili.line_item_amount) AS sum_of_line_item_amount
FROM general_ledger_accounts gla
	INNER JOIN	invoice_line_items ili
		ON ili.account_number = gla.account_number
GROUP BY
	gla.account_description
HAVING 
	COUNT(ili.invoice_id) > 1
ORDER BY
	SUM(ili.line_item_amount) DESC;

-- ----------------------- task 5

SELECT *
FROM invoices;

SELECT 
	-- gla.account_number,
	gla.account_description,
    COUNT(ili.invoice_id) AS no_of_invoices,
    SUM(ili.line_item_amount) AS sum_of_line_item_amount
FROM general_ledger_accounts gla
	INNER JOIN	invoice_line_items ili
		ON ili.account_number = gla.account_number
	INNER JOIN invoices i
		ON ili.invoice_id = i.invoice_id
WHERE
	i.invoice_date BETWEEN '2018-04-1' AND '2018-06-30'
GROUP BY
	gla.account_description
HAVING 
	COUNT(ili.invoice_id) > 1
ORDER BY
	SUM(ili.line_item_amount) DESC;

-- ----------------------- task 6

SELECT *
FROM general_ledger_accounts;

SELECT *
FROM invoice_line_items;

SELECT
	gla.account_number,
    SUM(ili.line_item_amount) AS sum
FROM general_ledger_accounts gla
	INNER JOIN invoice_line_items ili
		ON ili.account_number = gla.account_number
GROUP BY
	gla.account_number WITH ROLLUP;

-- ----------------------- task 7

SELECT *
FROM general_ledger_accounts;

SELECT *
FROM vendors;

SELECT *
FROM invoices;

SELECT *
FROM invoice_line_items;

SELECT
	v.vendor_name,
    COUNT(DISTINCT ili.account_number) AS no_of_acc
FROM vendors v
	INNER JOIN invoices i
		ON v.vendor_id = i.vendor_id
	INNER JOIN invoice_line_items ili
		ON ili.invoice_id = i.invoice_id
GROUP BY
	v.vendor_name
HAVING
	COUNT(DISTINCT ili.account_number) > 1
ORDER BY
	COUNT(DISTINCT i.invoice_id) DESC;
    
-- ----------------------- task 8

SELECT *
FROM terms;

SELECT *
FROM vendors;

SELECT *
FROM invoices;

SELECT
	IF(GROUPING(terms_id) = 1, 'Grand total', terms_id) AS terms_id,
    IF(GROUPING(vendor_id) = 1, 'Summary for term', vendor_id) AS vendor_id,
    payment_date,
    SUM(invoice_total - payment_total - credit_total) AS sum
FROM invoices
GROUP BY 
	terms_id,
	vendor_id 
    WITH ROLLUP
ORDER BY
	terms_id,
    vendor_id;

-- ----------------------- task 9

SELECT
	vendor_id,
    invoice_total - payment_total - credit_total AS balance_due,
	-- total balance due for all vendors in the invoices table
    SUM(invoice_total - payment_total - credit_total) OVER() AS total_balance_due,
    -- total balance due for each vendor in the invoices table // cumulative total by balance due
    SUM(invoice_total - payment_total - credit_total) OVER(PARTITION BY vendor_id ORDER BY (invoice_total - payment_total - credit_total)) AS vendor_total
FROM invoices
WHERE
	invoice_total - payment_total - credit_total > 0;

-- ----------------------- task 10

-- add column that calculates the average balance due for each vendor // cumulative average by balance due
-- modify SELECT statement so it uses a named window for the last two aggregate window functions

SELECT
	vendor_id,
    invoice_total - payment_total - credit_total AS balance_due,
	-- total balance due for all vendors in the invoices table
    SUM(invoice_total - payment_total - credit_total) OVER() AS total_balance_due,
    -- total balance due for each vendor in the invoices table // cumulative total by balance due
    SUM(invoice_total - payment_total - credit_total) OVER(vendor_window ORDER BY (invoice_total - payment_total - credit_total)) AS vendor_total,
    -- add column that calculates the average balance due for each vendor // cumulative average by balance due
    ROUND(AVG(invoice_total - payment_total - credit_total) OVER(vendor_window),2) AS avg_vendor_total
    
FROM invoices
WHERE
	invoice_total - payment_total - credit_total > 0
WINDOW vendor_window AS (PARTITION BY vendor_id);

-- ----------------------- task 11

-- moving average // frames

SELECT *
FROM invoices;

SELECT
	MONTH(invoice_date) AS mo,
    SUM(invoice_total) AS sum_of_the_invoice_total,
    ROUND(AVG(SUM(invoice_total)) OVER (ORDER BY MONTH(invoice_date)
		RANGE BETWEEN 3 PRECEDING AND CURRENT ROW), 2) AS 4_month_avg
FROM invoices
GROUP BY
	MONTH(invoice_date);

